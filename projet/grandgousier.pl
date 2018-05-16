/* --------------------------------------------------------------------- */
/*                                                                       */
/*        PRODUIRE_REPONSE(L_Mots,L_Lignes_reponse) :                    */
/*                                                                       */
/*        Input : une liste de mots L_Mots representant la question      */
/*                de l'utilisateur                                       */
/*        Output : une liste de liste de lignes correspondant a la       */
/*                 reponse fournie par le bot                            */
/*                                                                       */
/*        NB Pour l'instant le predicat retourne dans tous les cas       */
/*            [  [je, ne, sais, pas, '.'],                               */
/*               [les, etudiants, vont, m, '\'', aider, '.'],            */
/*               ['vous le verrez !']                                    */
/*            ]                                                          */
/*                                                                       */
/*        Je ne doute pas que ce sera le cas ! Et vous souhaite autant   */
/*        d'amusement a coder le predicat que j'ai eu a ecrire           */
/*        cet enonce et ce squelette de solution !                       */
/*                                                                       */
/* --------------------------------------------------------------------- */
sr([beaume|X],[beaumes|Y],X,Y).
sr([chateau|X],[ch|Y],X,Y).
sr([st|X],[saint|Y],X,Y).
sr([premier|X],['1er'|Y],X,Y).
sr([ch|X],[champagne|Y],X,Y).
sr([euro|X],[eur|Y],X,Y).
sr([euros|X],[eur|Y],X,Y).
/*                      !!!    A MODIFIER   !!!                          */

:- style_check(-discontiguous).
:- [db].
:- [nom_vins].

produire_reponse([fin],[L1]) :-
   L1 = [merci, de, m, '\'', avoir, consulte], !.

produire_reponse(L,Rep) :-
  simplify(L, LS),
  mclef(M,_), member(M,LS),
  clause(regle_rep(M,_,LPattern,Rep),Body),
  check_patterns(LPattern,LS),
  call(Body), !.

check_patterns([], _) :- false.
check_patterns([HeadPattern|Pattern], L):-
  match_pattern(HeadPattern, L);
  check_patterns(Pattern, L).

simplify(List,Result) :-
  sr(List,Result,X,Y), !,
	simplify(X,Y).

simplify([W|Words],[W|NewWords]) :- simplify(Words,NewWords).
simplify([],[]).

match_pattern([],_) :- false.
match_pattern(Pattern,Lmots) :-
   nom_vins_uniforme(Lmots,L_mots_unif),
   sublist(Pattern,L_mots_unif).

sublist(SL,L) :-
   prefix(SL,L), !.
sublist(SL,[_|T]) :- sublist(SL,T).


% ----------------------------------------------------------------%

regle_rep(conservation, 0,
[[conservation, _, Vin],
[conservation,Vin]
],
Rep) :-
conservation(Vin, Conservation),
Rep = [['la conservation conseillée de ce vin:', Conservation, '.']].

% ----------------------------------------------------------------%
regle_rep(bouche, 1,
[[bouche,_, Vin],
[Vin, _, bouche]
],
Rep ) :-
bouche(Vin,Rep).

% ----------------------------------------------------------------%

regle_rep(nez, 2,
[[nez, _, Vin ],
[Vin, _, nez]
],
Rep) :-
nez(Vin,Rep).

% ----------------------------------------------------------------%

regle_rep(vins,3,
[[vins, entre, X, et, Y, eur],
[vins, _, de, X, et, Y, eur]
],
Rep) :-
lvins_prix_min_max(X,Y,Lvins),
rep_lvins_min_max(Lvins,Rep).

rep_lvins_min_max([], [[ non, '.' ]]).
rep_lvins_min_max([H|T], [ [ oui, '.', je, dispose, de ] | L]) :-
rep_litems_vin_min_max([H|T],L).

rep_litems_vin_min_max([],[]) :- !.
rep_litems_vin_min_max([(V,P)|L], [Irep|Ll]) :-
nom(V,Appellation),
quantite(V,Q),
Irep = [ '- ', Appellation, '(', P, ' EUR /', Q, ')' ],
rep_litems_vin_min_max(L,Ll).

prix_vin_min_max(Vin,P,Min,Max) :-
prix(Vin,P),
Min =< P, P =< Max.

lvins_prix_min_max(Min,Max,Lvins) :-
findall( (Vin,P) , prix_vin_min_max(Vin,P,Min,Max), Lvins ).

% ----------------------------------------------------------------%
regle_rep(resume, 8,
[[resume, _,Vin ],
[Vin, resume],
[Vin, _, resume],
[resume, Vin]
],
Rep) :-
resume(Vin,Rep).

regle_rep(resumer, 8,
[[resumer, _,Vin ],
[Vin, resumer],
[Vin, _, resumer],
[resumer, Vin]
],
Rep) :-
resume(Vin,Rep).

regle_rep(dire, 4,
[[dire, _, _,Vin ],
[dire, _, Vin]
],
Rep) :-
description(Vin,Rep).

% ----------------------------------------------------------------%

regle_rep(vins, 5,
[[_,autres,vins, _, Region],
[_,dautres,vins, _, Region],
[_, Region,_, autres,vins],
[_, Region,_, dautres,vins]
],
Rep) :-
lvins_region(Region,Lvins),
length(Lvins, Nb),
Nbdemi is Nb div 2,
demi_list_sup(Lvins, Nbdemi, LvinsSup),
rep_lvins_region(LvinsSup,Rep).

regle_rep(vins, 5,
[[_,vins, _, Region],
[_,Region,_, vins]
],
Rep) :-
lvins_region(Region,Lvins),
length(Lvins, Nb),
Nbdemi is Nb div 2,
demi_list_inf(Lvins, Nbdemi, LvinsInf),
rep_lvins_region(LvinsInf,Rep).

rep_lvins_region([], [[ je, n, '\'', en, ai, pas, '.' ]]).
rep_lvins_region([H|T], [ [ oui, '.', je, dispose, de ] | L ]) :-
rep_litems_vin_region([H|T],L).

rep_litems_vin_region([],[]) :- !.
rep_litems_vin_region([(V,P)|L], [Irep|L1]) :-
nom(V,Appellation),
quantite(V,Q),
Irep = [ '- ', Appellation, '(', P, ' EUR ', Q, ')' ],
rep_litems_vin_region(L,L1).

vin_region(Vin,P,Region) :-
categorie(Vin,Region),
prix(Vin,P).

lvins_region(Region,Lvins) :-
findall( (Vin,P), vin_region(Vin,P,Region), Lvins).

demi_list_sup(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).
demi_list_inf(Src,N,L) :- findall(E, (nth1(I,Src,E), I > N), L).

% ----------------------------------------------------------------%

regle_rep(appellation, 6,
[[dire, _, appelation, _, Appellation],
[recouvre, _, appelation, _, Appellation],
[appelation, _, Appelation,_, recouvre],
[details, _, appelation, _, Appelation]
],
Rep) :-
 appellation(Appellation, Rep).

% ----------------------------------------------------------------%
regle_rep(accompagne, 7,
[[accompagne, _,Viande],
 [accompagne,Viande]
],
Rep) :-
  vin_nourriture(Viande, Description, Lvins),
  rep_litems_vin_accompagne(Lvins, LvinsA),
  union([Description], LvinsA, Rep).

rep_litems_vin_accompagne([],[]) :- !.
rep_litems_vin_accompagne([V|L], [Irep|L1]) :-
	nom(V,Appellation),
  prix(V,P),
	quantite(V,Q),
	Irep = [ '- ', Appellation, '(', P, ' EUR ', Q, ')'],
	rep_litems_vin_accompagne(L,L1).

/* --------------------------------------------------------------------- */
/*                                                                       */
/*          CONVERSION D'UNE QUESTION DE L'UTILISATEUR EN                */
/*                        LISTE DE MOTS                                  */
/*                                                                       */
/* --------------------------------------------------------------------- */

% lire_question(L_Mots)

lire_question(LMots) :- read_atomics(LMots).



/*****************************************************************************/
% my_char_type(+Char,?Type)
%    Char is an ASCII code.
%    Type is whitespace, punctuation, numeric, alphabetic, or special.

my_char_type(46,period) :- !.
my_char_type(X,alphanumeric) :- X >= 65, X =< 90, !.
my_char_type(X,alphanumeric) :- X >= 97, X =< 123, !.
my_char_type(X,alphanumeric) :- X >= 48, X =< 57, !.
my_char_type(X,whitespace) :- X =< 32, !.
my_char_type(X,punctuation) :- X >= 33, X =< 47, !.
my_char_type(X,punctuation) :- X >= 58, X =< 64, !.
my_char_type(X,punctuation) :- X >= 91, X =< 96, !.
my_char_type(X,punctuation) :- X >= 123, X =< 126, !.
my_char_type(_,special).


/*****************************************************************************/
% lower_case(+C,?L)
%   If ASCII code C is an upper-case letter, then L is the
%   corresponding lower-case letter. Otherwise L=C.

lower_case(X,Y) :-
	X >= 65,
	X =< 90,
	Y is X + 32, !.

lower_case(X,X).


/*****************************************************************************/
% read_lc_string(-String)
%  Reads a line of input into String as a list of ASCII codes,
%  with all capital letters changed to lower case.

read_lc_string(String) :-
	get0(FirstChar),
	lower_case(FirstChar,LChar),
	read_lc_string_aux(LChar,String).

read_lc_string_aux(10,[]) :- !.  % end of line

read_lc_string_aux(-1,[]) :- !.  % end of file

read_lc_string_aux(LChar,[LChar|Rest]) :- read_lc_string(Rest).


/*****************************************************************************/
% extract_word(+String,-Rest,-Word) (final version)
%  Extracts the first Word from String; Rest is rest of String.
%  A word is a series of contiguous letters, or a series
%  of contiguous digits, or a single special character.
%  Assumes String does not begin with whitespace.

extract_word([C|Chars],Rest,[C|RestOfWord]) :-
	my_char_type(C,Type),
	extract_word_aux(Type,Chars,Rest,RestOfWord).

extract_word_aux(special,Rest,Rest,[]) :- !.
   % if Char is special, do not read more chars.

extract_word_aux(Type,[C|Chars],Rest,[C|RestOfWord]) :-
	my_char_type(C,Type), !,
	extract_word_aux(Type,Chars,Rest,RestOfWord).

extract_word_aux(_,Rest,Rest,[]).   % if previous clause did not succeed.


/*****************************************************************************/
% remove_initial_blanks(+X,?Y)
%   Removes whitespace characters from the
%   beginning of string X, giving string Y.

remove_initial_blanks([C|Chars],Result) :-
	my_char_type(C,whitespace), !,
	remove_initial_blanks(Chars,Result).

remove_initial_blanks(X,X).   % if previous clause did not succeed.


/*****************************************************************************/
% digit_value(?D,?V)
%  Where D is the ASCII code of a digit,
%  V is the corresponding number.

digit_value(48,0).
digit_value(49,1).
digit_value(50,2).
digit_value(51,3).
digit_value(52,4).
digit_value(53,5).
digit_value(54,6).
digit_value(55,7).
digit_value(56,8).
digit_value(57,9).


/*****************************************************************************/
% string_to_number(+S,-N)
%  Converts string S to the number that it
%  represents, e.g., "234" to 234.
%  Fails if S does not represent a nonnegative integer.

string_to_number(S,N) :-
	string_to_number_aux(S,0,N).

string_to_number_aux([D|Digits],ValueSoFar,Result) :-
	digit_value(D,V),
	NewValueSoFar is 10*ValueSoFar + V,
	string_to_number_aux(Digits,NewValueSoFar,Result).

string_to_number_aux([],Result,Result).


/*****************************************************************************/
% string_to_atomic(+String,-Atomic)
%  Converts String into the atom or number of
%  which it is the written representation.

string_to_atomic([C|Chars],Number) :-
	string_to_number([C|Chars],Number), !.

string_to_atomic(String,Atom) :- name(Atom,String).
  % assuming previous clause failed.


/*****************************************************************************/
% extract_atomics(+String,-ListOfAtomics) (second version)
%  Breaks String up into ListOfAtomics
%  e.g., " abc def  123 " into [abc,def,123].

extract_atomics(String,ListOfAtomics) :-
	remove_initial_blanks(String,NewString),
	extract_atomics_aux(NewString,ListOfAtomics).

extract_atomics_aux([C|Chars],[A|Atomics]) :-
	extract_word([C|Chars],Rest,Word),
	string_to_atomic(Word,A),       % <- this is the only change
	extract_atomics(Rest,Atomics).

extract_atomics_aux([],[]).


/*****************************************************************************/
% clean_string(+String,-Cleanstring)
%  removes all punctuation characters from String and return Cleanstring

clean_string([C|Chars],L) :-
	my_char_type(C,punctuation),
	clean_string(Chars,L), !.
clean_string([C|Chars],[C|L]) :-
	clean_string(Chars,L), !.
clean_string([C|[]],[]) :-
	my_char_type(C,punctuation), !.
clean_string([C|[]],[C]).


/*****************************************************************************/
% read_atomics(-ListOfAtomics)
%  Reads a line of input, removes all punctuation characters, and converts
%  it into a list of atomic terms, e.g., [this,is,an,example].

read_atomics(ListOfAtomics) :-
	read_lc_string(String),
	clean_string(String,Cleanstring),
	extract_atomics(Cleanstring,ListOfAtomics).



/* --------------------------------------------------------------------- */
/*                                                                       */
/*        ECRIRE_REPONSE : ecrit une suite de lignes de texte            */
/*                                                                       */
/* --------------------------------------------------------------------- */

ecrire_reponse(L) :-
   nl, write('GGS :'),
   ecrire_li_reponse(L,1,1).

% ecrire_li_reponse(Ll,M,E)
% input : Ll, liste de listes de mots (tout en minuscules)
%         M, indique si le premier caractere du premier mot de
%            la premiere ligne doit etre mis en majuscule (1 si oui, 0 si non)
%         E, indique le nombre d espaces avant ce premier mot

ecrire_li_reponse([],_,_) :-
    nl.

ecrire_li_reponse([Li|Lls],Mi,Ei) :-
   ecrire_ligne(Li,Mi,Ei,Mf),
   ecrire_li_reponse(Lls,Mf,2).

% ecrire_ligne(Li,Mi,Ei,Mf)
% input : Li, liste de mots a ecrire
%         Mi, Ei booleens tels que decrits ci-dessus
% output : Mf, booleen tel que decrit ci-dessus a appliquer
%          a la ligne suivante, si elle existe

ecrire_ligne([],M,_,M) :-
   nl.

ecrire_ligne([M|L],Mi,Ei,Mf) :-
   ecrire_mot(M,Mi,Maux,Ei,Eaux),
   ecrire_ligne(L,Maux,Eaux,Mf).

% ecrire_mot(M,B1,B2,E1,E2)
% input : M, le mot a ecrire
%         B1, indique si il faut une majuscule (1 si oui, 0 si non)
%         E1, indique si il faut un espace avant le mot (1 si oui, 0 si non)
% output : B2, indique si le mot suivant prend une majuscule
%          E2, indique si le mot suivant doit etre precede d un espace

ecrire_mot('.',_,1,_,1) :-
   write('. '), !.
ecrire_mot('\'',X,X,_,0) :-
   write('\''), !.
ecrire_mot(',',X,X,E,1) :-
   espace(E), write(','), !.
ecrire_mot(M,0,0,E,1) :-
   espace(E), write(M).
ecrire_mot(M,1,0,E,1) :-
   name(M,[C|L]),
   D is C - 32,
   name(N,[D|L]),
   espace(E), write(N).

espace(0).
espace(N) :- N>0, Nn is N-1, write(' '), espace(Nn).


/* --------------------------------------------------------------------- */
/*                                                                       */
/*                            TEST DE FIN                                */
/*                                                                       */
/* --------------------------------------------------------------------- */

fin(L) :- member(fin,L).


/* --------------------------------------------------------------------- */
/*                                                                       */
/*                         BOUCLE PRINCIPALE                             */
/*                                                                       */
/* --------------------------------------------------------------------- */

grandgousier :-

   nl, nl, nl,
   write('Bonjour, je suis Grandgousier, GGS pour les intimes,'), nl,
   write('conseiller en vin. En quoi puis-je vous etre utile ?'),
   nl, nl,

   repeat,
      write('Vous : '),
      lire_question(L_Mots),
      produire_reponse(L_Mots, L_ligne_reponse),
      ecrire_reponse(L_ligne_reponse),
   fin(L_Mots), !.


/* --------------------------------------------------------------------- */
/*                                                                       */
/*             ACTIVATION DU PROGRAMME APRES COMPILATION                 */
/*                                                                       */
/* --------------------------------------------------------------------- */

:- grandgousier.
