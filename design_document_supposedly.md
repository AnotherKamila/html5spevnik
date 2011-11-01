Hlboka pointa
=============

 * prijemny spevnik s feelingom ako papierovy, ale majuci uzitok z toho ze je
   elektronicky (takze chceme vediet *dobre* vyhladavat a pod.)
 * priatelsky k touchscreen veciam, k devicom typu moj mobil a k uzivatelom
 * fungujuci offline

Nie az tak hlboka pointa
========================

vyskusat si napisat semiserioznu web app, skamaratit sa s html5 featurami

Co si myslim ze bude v backende
===============================

Databaza
--------

IndexedDB (TODO a co android?)

 * veci v databaze su objekty indexovane podla cohosi (vsetkeho okrem data
   zrejme) -- mozno nieco ako
   ```
   {
       artist: "Spirituál Kvintet",
       title:  "Batalion",
       categories: [
           "České",
           "Something Something",
           "..."
       ],
       data: {
          text: "<<Ami>>Víno <<C>>máš ..."
       }
   }
   ```
   Teda properties su vsetky metadata + objekt data obsahujuci
   content.

 * IndexedDB specifikacia hovori o verzii databazy. To sa chystam zneuzit
   nasledovne:
    * Verzia je string. U mna bude verzia Spevnik.Version + '+' + (kratke nazvy
      pluginov).join(','). Takto mam okrem verzie jednoznacne urceny popis
      (,,tvar'') databazy, co sa chystam patricne zneuzivat.
      (Note: ak by boli metadata pluginy, tak (nazvy metadata
      pluginov).join(',') + ';' + (nazvy data pluginov).join(','); ak by som
      mala hierarchiu metapluginov (co nepredpokladam), tak by to bolo for p in
      activeMetaPlugins DB.version += p.name + ':' + (nazvy aktivnych pluginov ktore ma na
      starosti tento metaplugin).join(',') + ';' alebo cosi take, nech naozaj
      mam jednoznacnu informaciu o celej strukture.)
    * DB.init() by vyzeralo nasledovne:
      1. Ak ziadna databaza neexistuje, tak si ju vyrob. (Mozes prazdnu, teda
         neondit sa s indexami, na to je krok 2.)
      2. Zober zoznam aktivnych pluginov. (Pluginy sa teda musia registrovat
         pred tymto.) Pozri si description databazy, ak nezodpoveda aktivnym
         pluginom, tak zavolaj setVersion s updatnutou description a vyrob na
         tom take indexy ake podla pluginov treba.
      3. Ak sa lisia v ciselku, mohlo sa stat, ze sa nieco zmenilo. Takze
         zavolam Spevnik.Updater.DBUpgrade, co spravi request =
         idb.setVersion(daco); request.onsuccess = nieco (kde nieco je vysoko
         pravdepodobne $empty, kedze vsetky indexy asi riesia pluginy a teda
         step 2, ale one never knows). Ak to bude tak ze vsetky indexy riesia
         pluginy teda step 2 tak toto vobec netreba.

 * Chystam sa mat nejaky zmysluplny ,,primary key''? Asi mozno ani velmi nie,
   neviem co do neho totiz. Zrejme to necham na key generatoroch (vid IndexedDB
   API @ MDN).

 * What about duplicates? Nechat a vidiet uzivatela ako nadava ze ma veci 2krat?
   Urvat a vidiet uzivatela ako nadava ze on tam chcel 2 rozne verzie? Spravit na to
   setting? This is a TODO.
   (Pravdepodobne chcem checkbox pri uploade, nieco na sposob Merge records with
   the same metadata, a este mozno if checked tak ci overwritovat stare alebo
   nie)

 * Uh, prave ma napadlo, ze mozno chcem vediet napr. najst len take pesnicky na
   ktore mam taby. Takze treba indexovat aj podla toho, ci je data[nieco]
   undefined alebo nie. Netusim ci sa mi toto paci. Mozno to budem len zaradom
   filtrovat, ved tych pesniciek nejde byt 10^6. Keby som chcela indexovat, tak
   totiz indexujem cely velky obsah, nie len ci to je undefined.

File Uploader interface / whatever
----------------------------------

Uzivatel moze uploadnut co len chce. Nasledne je na pluginoch, aby s tym cosi
robili. Cez mime typy nefici, lebo taky plain text asi bude mat vela pluginov.
Takze inak: Podhodim file handle kazdemu pluginu, plugin moze bud povedat "OK"
alebo "A toto co je?". (Taky text povie "OK" ak vidi textak pripominajuci ten
format, povie "A toto co je?" ked vidi obrazok alebo textak ktory
rozhodne nepripomina ten format.) Nemuselo by sa stavat, ze by viac ako 1 plugin
povedal OK, ale treba s tym pocitat, v tomto pripade si uzivatel vyberie co tym
suborom myslel. (Napr. ak budu sheet music aj guitar tabs brat obrazky tak tie
rozhodne rozoznavat nejdem.)

Plugin by taktiez mal povedat, ci od uzivatela potrebuje nejake dalsie info.
Napr. v textakoch su metadata napisane, ale v obrazkoch nie su, takze na
pridanie do databazy ich uzivatel musi vyplnit. Starost pluginu je povedat "Toto
mi chyba", vypytat si to je na Uploaderi.

Edit: poriadnejsie opisane nizsie

Odvec 0: Zufalo pluggable architektura
======================================

Disclaimer: Nasledujuce vysoko pravdepodobne vobec nedava zmysel.

Stage 1: Este OK
----------------

Mne su napr. gitarove taby nanic, lebo neviem hrat na gitare. Niekomu inemu
nanic byt nemusia. Podobnymi uvahami som sa dopracovala k tomu, ze veci co
zobrazuju data by mali byt pluginy. Vyzerat to chce nasledovne:

Existuje funkcia `RegisterPlugin`, ktora dostava opis toho, co plugin chce robit.
Fungovat to ide tak, ze `RegisterPlugin` dostane

 * String `name`: unique nazov pluginu (pr.: "text" pre zobrazovatko textu+akordov,
   "sheet" pre zobrazovatko not)
   * `RegisterPlugin` sa postara o to, ze prototyp objektov v databaze dostane
     novu property `data[name]` a updatne buducu database description, @see [Database]
 * String `longName` alebo `description`: human-friendly nazov (uzitocny
   napriklad v uploaderi)
 * funkciu, ktora zapisuje do databazy pri pridani novych dat (dostane
   uploadnuty subor, asi vo forme file handle, a vratit ma jednak objekt ktory
   sa zavesi na `data[name]` k prislusnym metadatam, a jednak objekt obsahujuci
   metadata co ten plugin zistil zo suboru (aby uploader pytal len to co treba)
 * funkciu, ktora zobrazuje: dostane `data[name]` toho objektu co
   chcem zobrazit, a ma mi vratit HTML ktore sa injectne do view area divu

(asi zabalene v objekte, nieco na sposob plugin ma exports obsahujuci toto)

Doriesit este treba rypanie do inych casti UI ako viewArea (a na to musia byt
bindnute eventy interagujuce s HTML vo view area dive, priklad text plugin ma
vediet transponovat akordy, cize v current song settings ma byt slider/input na
nastavenie transponovania, a akordy vo viewArea sa maju prislusne zmenit; ten
plugin by taktiez mohol vediet zobrazovat nejake overlaye alebo nieco, priklad:
klik na akord ma vyplut ako sa hra)

Dodatok: Pluginy si maju pripadne obrazky a pod. nosit v data urls, lebo manifest je
staticky, teda plugin nevie referencovat nic outside, lebo by to nefungovalo
offline. Toto mozno neni uplne dobre, a mozno to nevadi.

Stage 2: Este stale OK
----------------------

Nasledny myslienkovy pochod: Ale ja som napriklad bola aj cely zivot leniva
babrat sa s ratingami, zatialco niekto iny ich moze mat rad, takze mozno by to
chcelo nejaky `RegisterMetadataPlugin`, ktory by vedel pridat novy typ metadat
(teda veci podla ktorych sa da indexovat DB) a taktiez rypat do UI kedze chceme
aby tie metadata na nieco boli. A podobne, mozno ma totiz niekedy napadne este
iny typ pluginu. Teda mam 2 moznosti: bud mat hrbu fcii na sposob
`RegisterDataPlugin`, `RegisterMetadataPlugin`, `RegisterBlahPlugin`, alebo mat
fciu `RegisterPlugin(String type, Object nejake_tie_veci_na_styl_toho_hore)`,
kde type je bud "data" alebo "metadata" alebo "blah".

Odvec: Dalsi typ pluginu: nejaky cisto interfacovy, priklad: AutoScroller,
scrolluje view area nastavitelnou rychlostou.

Odvec 2: Playlisty by bol metadata plugin? Ehm, mozno to chce typ pluginu co
vie vyrabat vlastne object stores v databaze...  
(Also, playlisty by to chcelo sharovat, ale to budem riesit ked bude core
hotovy.)

Odvec 3: Kolko ma toho este napadne? Zacinam mat pocit ze Stage 3 mozno nebude
umazana tak rychlo ako som ocakavala :-D

Stage 3: Toto uz vobec neni OK
------------------------------

Predstavme si scenario `RegisterPlugin(type, { stuff... })`. Co je type? Je to
nieco fixne, dane core funkcionalitou spevnika? Uchylny napad: Je to cokolvek, s
cim vedia robit aktivne metapluginy. Teda viem napisat metaplugin, ktory
zadefinovava, ze RegisterPlugin pozna typ nieco, a vie, co s objektom pre plugin
typu nieco robit.

Toto znie dostatocne sialene na to, aby to bolo zaujimave, ale nemam tusenia ci
to vobec ide. Metapluginy by totiz potrebovali sposob, ako sa hooknut prakticky
kamkolvek, aby vedeli providnut funkcionalitu pre lubovolny typ pluginu. Brr,
nemam ani tusenia ako by sa to kodilo.

Chcelo by to rozmysliet/vymysliet. Na jednej strane by to bolo cool, na druhej
strane netreba prehanat, nechceme metametametametapluginy. (Ci? :-D)

Odvec 1: Server side
====================

Vzhladom na point ,,fungujuci offline'' vela netreba. Prakticky mi staci
kamsi zavesit zopar pesniciek a spravit k tomu pekny interface na stiahnutie
(idealne by to mohlo zipovat, nech netreba po jednom, a ak by to bol zip (co je
asi predsalen pohodlnejsie) tak mi automaticky odpadava starost s integraciou do
spevnika, lebo aspon zatial upload zipu nepodporujem, takze uzivatel to aj tak
bude musiet rucne odzipovat, cize musi aj rucne uploadnut lebo ktovie kam to
odzipoval a podobne vyhovorky)

Odvec 2: Dilema s akordami rozriesena (takmer)
==============================================

Filtrovat podla akordov je hlupost, neviem si predstavit uzivatela co by si to
nastavoval. (A navyse by sa to hnusne kodilo, a navyse by to nesedelo do tej
predstavy data vs. metadata, a navyse by sa to fakt hnusne kodilo.)

Transponovat blbost nie je, transponovat chcem vediet. To ale
znamena, ze pluginy musia mat sposob ako sa hooknut do UI (lebo chceme vediet
transponovat aj bez toho ze by sme si museli otvorit debug konzolu). Toto
vymysliet je TODO.

Edit: Sucastou handlera pre 'data' typ pluginu je
aj fcia ,,Hod po mne HTML co by si chcel mat tam a tam (pre 'data' je asi jedina
moznost v settings screene pre momentalnu pesnicku) a ja ho tam dam''.
