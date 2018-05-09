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

nom_vins_uniforme(Lmots,L_mots_unif) :-
   L1 = Lmots,
   replace_vin([beaumes,de,venise],beaumes_de_venise_2015,L1,L2),
   replace_vin([chaboeufs],les_chaboeufs_2013,L2,L3),
   replace_vin([ch,moulin,maillet], ch_moulin_maillet_2014, L3, L4),
   replace_vin([ch,fleur,baudron], ch_fleur_baudron_2014, L4, L5),
   replace_vin([ch,paret], ch_paret_2012, L5, L6),
   replace_vin([ch,menota,cuvee,montgarede], ch_menota_cuvee_montgarede_2014, L6, L7),
   replace_vin([madiran,vieilles,vignes], madiran_vieilles_vignes_2016, L7, L8),
   replace_vin([ch,moulin,neuf,cuvee,prestige], ch_moulin_neuf_cuvee_prestige_2014, L8, L9),
   replace_vin([ch,milon,la,grave,cuvee,part], ch_milon_la_grave_cuvee_part, L9, L10),
   replace_vin([ch,roc,de,binet], ch_roc_de_binet_2010, L10, L11),
   replace_vin([ch,ruat,petit,poujeaux], ch_ruat_petit_poujeaux_2010, L11, L12),
   replace_vin([ch,les,polyanthas], ch_les_polyanthas_2010, L12, L13),
   replace_vin([ch,la,menotte], ch_la_menotte_2012, L13, L14),
   replace_vin([fleur,de,pomys], fleur_de_pomys_2012, L14, L15),
   replace_vin([florilege,pauillac], florilege_pauillac_2011, L15, L16),
   replace_vin([florilege,saint,julien], florilege_saint_julien_2011, L16, L17),
   replace_vin([florilege,pomerol], florilege_pomerol_2012, L17, L18),
   replace_vin([syrah,2015], syrah_2015, L18, L19),
   replace_vin([cotes,rhone,villages,2014], cotes_rhone_villages_2014, L19, L20),
   replace_vin([tautavel,2014], tautavel_2014, L20, L21),
   replace_vin([lirac,2015], lirac_2015, L21, L22),
   replace_vin([cairanne,2014], cairanne_2014, L22, L23),
   replace_vin([vacqueyras,2014], vacqueyras_2014, L23, L24),
   replace_vin([saint,joseph,2014], saint_joseph_2014, L24, L25),
   replace_vin([gigondas,2014], gigondas_2014, L25, L26),
   replace_vin([chateauneuf,du,pape,rouge], chateauneuf_du_pape_rouge_2013, L26, L27),
   replace_vin([hermitage,rouge], hermitage_rouge_2007, L27, L28),
   replace_vin([coteaux,bourguignons], coteaux_bourguignons_2014, L28, L29),
   replace_vin([bourgogne,pinot,noir], bourgogne_pinot_noir_2014, L29, L30),
   replace_vin([hautes,cotes,de,nuits], hautes_cotes_de_nuits_2014, L30, L31),
   replace_vin([savigny,les,beaune], savigny_les_beaune_2014, L31, L32),
   replace_vin([savigny,les,beaune,'1er',cru,_], savigny_les_beaune_1er_cru_2014, L32, L33),
   replace_vin([aloxe,corton], aloxe_corton_2014, L33, L34),
   replace_vin([nuits,saint,georges,'1er',cru], nuits_saint_georges_1er_cru_2013, L34, L35),
   replace_vin([chambolle,musfigny,'1er',cru], chambolle_musfigny_1er_cru_2012, L35, L36),
   replace_vin([chiroubles], chiroubles_2013, L36, L37),
   replace_vin([fleurie], fleurie_2015, L37, L38),
   replace_vin([moulin,a,vent], moulin_a_vent_2014, L38, L39),
   replace_vin([chinon,vieilles,vignes], chinon_vieilles_vignes_2014, L39, L40),
   replace_vin([sancerre,rouge], sancerre_rouge_2015, L40, L41),
   replace_vin([les,guignards], les_guignards_2015, L41, L42),
   replace_vin([chardonnay,exception], chardonnay_exception_2016, L42, L43),
   replace_vin([vire,clesse], vire_clesse_2016, L43, L44),
   replace_vin([sancerre,blanc], sancerre_blanc_2015, L44, L45),
   replace_vin([vacqueyras,2016], vacqueyras_2016, L45, L46),
   replace_vin([hautes,cotes,de,beaume], hautes_cotes_de_beaume_2015, L46, L47),
   replace_vin([pouilly,fuisse], pouilly_fuisse_2014, L47, L48),
   replace_vin([chablis,'1er',cru,montmains], chablis_1er_cru_montmains_2014, L48, L49),
   replace_vin([condrieu,2015], condrieu_2015, L49, L50),
   replace_vin([cremant,de,loire,brut], cremant_de_loire_brut, L50, L51),
   replace_vin([champagne,brut,reserve], champagne_brut_reserve, L51, L52),
   replace_vin([champagne,extra,brut], champagne_extra_brut, L52, L53),
   replace_vin([champagne,brut,oeil,de,perdrix], champagne_brut_oeil_de_perdrix, L53, L54),
   replace_vin([champagne,brut,rose,de,saignee], champagne_brut_rose_de_saignee, L54, L55),
   replace_vin([champagne,brut,or,blanc], champagne_brut_or_blanc, L55, L56),
   replace_vin([champagne,brut,prestige], champagne_brut_prestige, L56, L57),
   replace_vin([cognac,trois,etoiles], cognac_trois_etoiles, L57, L58),
   replace_vin([cognac,fine,champagne], cognac_fine_champagne, L58, L59),
   replace_vin([cognac,grand,champagne], cognac_grand_champagne, L59, L60),

   L_mots_unif = L60.

replace_vin(L,X,In,Out) :-
   append(L,Suf,In), !, Out = [X|Suf].
replace_vin(_,_,[],[]) :- !.
replace_vin(L,X,[H|In],[H|Out]) :-
   replace_vin(L,X,In,Out).


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
   write(Vin),
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
