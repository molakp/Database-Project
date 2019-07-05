# Quqery Laboratorio Database #

**Query 1**
*Richiesta*:
Contare il numero di lingue in cui le release contenute nel database sono scritte (il risultato deve contenere soltanto il numero delle lingue, rinominato
“Numero_Lingue”).

*Commento*:
Nella prima query si può constatare che il risultato restituito dalla interrogazione è corretto
semplicemente contando il numero di lingue e confrontandolo con quelle realmente
presenti,come chiave abbiamo una unica chiave esterna nell’entità RELEASE che
corrisponde a language.
```SQL
select count(distinct language) as Numero_Lingue
from release
```
**Query 2**

Richiesta:

Elencare gli artisti che hanno cantato canzoni in italiano (il risultato deve contenere il nome dell’artista e il nome della lingua).

Commento:

La seconda interrogazione ci permette di ricavare quali artisti hanno cantato una canzone in
lingua italiana e le entità usate sono artista e lingua.
Le entità Artist e Language hanno come primary key ID e Artist ha come foreign key gli attributi type, gender e area.
```SQL
select artist.name as Nome_artista,language.name as Lingua_canzone
from artist,language
where language.name = 'Italiano'
```
**Query 3**
Richiesta:
Elencare le release di cui non si conosce la lingua (il risultato deve contenere soltanto
il nome della release).
Commento:
La risoluzione della seguente query richiedeva che la lingua della canzone fosse sconosciuta quindi si è potuto confrontare il risultato dell’interrogazione con i dati della tabella e assicurarsi che entrambe avessero nel campo lingua un valore NULL, le chiavi sono le stesse della query 1
```SQL
select name
from release
where language is NULL
```
**Query 4**
Richiesta:
Elencare gli artisti il cui nome contiene tutte le vocali ed è composto da una sola parola (il risultato deve contenere soltanto il nome dell’artista).
Commento:
Per questa richiesta, abbiamo selezionato il nome degli artisti dalla tabella Artist ,quindi, tramite il comando like abbiamo constatato che effettivamente nel nome di un artista fossero presenti tutte le vocali richieste.
```SQL
select artist.name
from artist
where artist.name like '%a%'
and artist.name like '%e%'
and artist.name like '%i%'
and artist.name like '%o%'
and artist.name like '%u%'
and artist.name not like '% %'
```
**Query 5**
Richiesta:
Elencare tutti gli pseudonimi di Prince con il loro tipo, se disponibile (il risultato deve contenere lo pseudonimo dell'artista, il nome dell’artista (cioè Prince) e il tipo di
pseudonimo (se disponibile)).
Commento:
Per la risoluzione della seguente query è risultato sufficiente assicurarsi che ogni tupla
presente nel risultato contenesse nel nome la parola “Prince”.
```SQL
select sort_name,name,type
from artist
where name like '%Prince%
```
**Query 6**
Richiesta :
Elencare le release di gruppi inglesi ancora in attività (il risultato devecontenere il nome del gruppo e il nome della release e essere ordinato per nome del gruppo e nome della release)
Commento:
Nella seguente query abbiamo utilizzato le entità Artist, release e area per ricavare i gruppi Inglesi in attività verificando che l’area fosse uguale a “United Kingdom” e che il valore dell’attributo artist.ended è diverso da true.
```SQL
select distinct artist.name, release.name
from artist,release,area join area_type on (area.type = area_type.id)
where area_type.id = '1' and area.name = 'United Kingdom'
and artist.ended <> 'true' and release.artist_credi t = artist.id
order by artist.name ASC
```
**Query 7**
Richiesta:
Trovare le release in cui il nome dell’artista è diverso dal nome accreditato nella release (il risultato deve contenere il nome della release, il nome dell’artista accreditato (cioè artist_credit.name) e il nome dell’artista(cioè artist.name) ).
Commento:
Nella risoluzione della settima query viene stampato il nome accreditato dell’artista il quale però deve avere un nome diverso dal proprio, per farlo abbiamo innanzitutto eseguito un join tra le relazioni interessate e successivamente abbiamo imposto come vincolo appunto che
```SQL 
artist_credit.name <> artist.name 
```
Query
```SQL
select distinct artist_credit.name,artist.name,release.name
from ((artist_credit join artist_credit_name
on artist_credit_name.artist_credit = artist_credit.id)
join artist on artist_credit_name.artist = artist.id)
join release on(release.artist_credit = artist_credit.id)
where artist_credit.name <> artist.name
```
**Query 8**
Richiesta:
Trovare gli artisti con meno di tre release (il risultato deve contenere il nome dell’artista ed il numero di release).
Commento:
Qui abbiamo eseguiti vari join tra le rispettive relazioni, eseguito un raggruppamento delle release degli artisti per nome dato che ogni artista doveva aver pubblicato almeno 3 release ed infine viene imposto come vincolo quello di avere 3 release sotto il proprio nome.
```SQL
select artist.name,count(release.name)
from ((artist_credit join artist_credit_name
on artist_credit_name.artist_credit = artist_credit.id)
join artist on artist_credit_name.artist = artist.id)
join release on(release.artist_credit = artist_credit.id)
group by artist.name
having count(release.name) <3
```
**Query 9**
Richiesta:
Trovare la registrazione più lunga di un’artista donna (il risultato deve contenere il nome della registrazione, la sua durata in minuti e il nome dell’artista; tenere conto che le durate sono memorizzate in millesimi di secondo) (scrivere due versioni della query con e senza operatore aggregato MAX).
***Versione A***
Commento:
Nella prima versione abbiamo una sottoquery che opportunamente restituisce la registrazione più lunga di un’artista donna,verifichiamo che il risultato della sottoquery(registrazione più lunga di un’artista donna) sia uguale alla lunghezza della registrazione di tutta la tabella, infine viene fatta una proiezione del nome dell’artista,del nome della registrazione e della lunghezza della registrazione già calcolata in minuti.
```SQL
select artist_credit.name,recording.name, recording.length/60000 as MaxLenght
from recording, artist_credit
where recording.artist_credit = artist_credit.id
and recording.length = (
select max(distinct recording.length) as MaxDurata
from artist_credit, recording, artist, gender
where recording.artist_credit = artist_credit.id
and artist.id = artist_credit.id
and artist.gender = gender.id
and gender.name = 'Female')
```
***Versione B***
Commento:
Nella seconda versione invece facciamo una selezione delle registrazioni femminili e facciamo una ricerca in modo che esistano registrazioni più lunghe di quella, dopodichè proiettiamo il nome della registrazione, la sua lunghezza e l’artista che ha prodotto quella canzone.
```SQL
select recording.name, recording.length/60000,artist_credit.name
from recording ,artist_credit,gender,artist
whererecording.artist_credit = artist_credit.id and artist.id=artist_credit.id
and artist.gender=gender.id and gender.name='Female' and recording.length
is not null and not exists(select R2.length
from recording R2 ,artist_credit,gender,artist
where R2.id <> recording.id
and R2.length>recording.length
and R2.artist_credit = artist_credit.id
and artist.id=artist_credit.id
and artist.gender=gender.id
and gender.name='Female'
and R2.length is not null)
```
**Query 10**
Richiesta:
Elencare le lingue cui non corrisponde nessuna release (il risultato deve contenere il nome della lingua, il numero di release in quella lingua, cioè 0, e essere ordinato per lingua (scrivere due versioni della query).
***Versione A***
Commento:
Per la versione A prima ci ricaviamo una tabella con tutte le lingue e contiamo le rispettive release, a questa sottraiamo(con il comando except) tutte le lingue che hanno una release.
```SQL
select distinct language.name,count (distinct release.id)
from language left join release on (release.language=language.id)
group by language.name
except
select language.name,count (distinct release.id)
from language,release
where language.id=release.language
group by language.name
```
 ***Versione B***
Commento:
Nella seconda versione selezioniamo il nome della lingua e contiamo gli id delle release facendo un left join tra language e release verificando che l’id della release sia diverso da null,infine li raggruppiamo per nome della lingua.
```SQL
select distinct language.name,count (distinct release.id)
from language left join release on (release.language = language.id)
where release.id is null
group by language.name
```
**Query 11**
Richiesta:
Ricavare la seconda registrazione per lunghezza di un artista uomo (il risultato deve comprendere l'artista accreditato, il nome della registrazione e la sua lunghezza) (scrivere due versioni della query).
***Versione A***
Commento:
Per la versione A sono state usate tre query annidate,con la prima otteniamo tutti i nomi degli artisti e le registrazioni con i rispettivi nomi e lunghezze, di questa con il comando not
con la seconda query prendiamo solo la seconda registrazione più lunga togliendo la registrazione più lunga con la terza query.
```SQL
SELECT DISTINCT recording.name,
         recording.length/60000 AS MaxLenght,
        artist.name
FROM recording
JOIN artist_credit
    ON recording.artist_credit = artist_credit.id
JOIN artist_credit_name
    ON artist_credit_name.artist_credit = artist_credit.id
JOIN artist
    ON artist_credit_name.artist =artist.id
WHERE recording.length IN 
    (SELECT max(recording.length)
    FROM recording
    JOIN artist_credit
        ON recording.artist_credit = artist_credit.id
    JOIN artist_credit_name
        ON artist_credit_name.artist_credit = artist_credit.id
    JOIN artist
        ON artist_credit_name.artist = artist.id
    WHERE artist.gender = 1
            AND recording.length NOT IN 
        (SELECT max(distinct recording.length) AS MaxDurata
        FROM recording
        JOIN artist_credit
            ON recording.artist_credit = artist_credit.id
        JOIN artist_credit_name
            ON artist_credit_name.artist_credit = artist_credit.id
        JOIN artist
            ON artist_credit_name.artist =artist.id
        WHERE artist.gender = 1 ) )
```
***Versione B***
Commento :
Anche qui utilizziamo lo stesso ragionamento della versione precedente, con la differenza che troviamo la seconda registrazione più lunga, verificando che la lunghezza della registrazione della terza query(che è quella più lunga in assoluto) sia maggiore di tutte le lunghezze di registrazione della seconda(ottenendo quindi la seconda più lunga),a questo punto non ci rimane che estrarre con la prima select nome dell’artista,nome e lunghezza della registrazione con lunghezza registrazione uguale al risultato della seconda sottoquery.
```SQL
SELECT DISTINCT recording.name,
         recording.length/60000 AS MaxLenght,
        artist.name
FROM recording
JOIN artist_credit
    ON recording.artist_credit = artist_credit.id
JOIN artist_credit_name
    ON artist_credit_name.artist_credit = artist_credit.id
JOIN artist
    ON artist_credit_name.artist = artist.id
WHERE recording.length IN 
    (SELECT max(recording.length)
    FROM recording
    JOIN artist_credit
        ON recording.artist_credit = artist_credit.id
    JOIN artist_credit_name
        ON artist_credit_name.artist_credit = artist_credit.id
    JOIN artist
        ON artist_credit_name.artist =artist.id
    WHERE artist.gender = 1
            AND recording.length < 
        (SELECT max(distinct recording.length) AS MaxDurata
        FROM recording
        JOIN artist_credit
            ON recording.artist_credit = artist_credit.id
        JOIN artist_credit_name
            ON artist_credit_name.artist_credit = artist_credit.id
        JOIN artist
            ON artist_credit_name.artist = artist.id
        WHERE artist.gender = 1 ) )
```
***Query 12***
Richiesta:
Per ogni stato esistente riportare la lunghezza totale delle registrazioni di artisti di quello stato (il risultato deve comprendere il nome dello stato e la lunghezza totale in minuti delle registrazioni (0 se lo stato non ha registrazioni)(scrivere due versioni della query).
***Versione A***
Commento:
Per la prima versione della query abbiamo innanzitutto ricavato l’ID di tutti gli artisti che hanno rilasciato una release, poi con la query esterna eseguo dei join tra le opportune tabelle con il vincolo area_type.name = 'Country' ed estraggo quindi solo gli id degli artisti presenti nel risultato della seconda sottoquery.
```SQL
SELECT area.name,
         coalesce(sum(recording.length)/60000,0)
FROM area
LEFT JOIN artist
    ON artist.area = area.id
LEFT JOIN artist_credit_name
    ON artist_credit_name.artist=artist.id
LEFT JOIN artist_credit
    ON artist_credit.id = artist_credit_name.artist_credit
LEFT JOIN recording
    ON recording.artist_credit=artist_credit.id
LEFT JOIN area_type
    ON area_type.id=area.type
WHERE area_type.name = 'Country'
        AND artist.id in
    (SELECT artist.id
    FROM artist
    LEFT JOIN artist_credit_name
        ON artist.id = artist_credit_name.artist
    JOIN artist_credit
        ON artist_credit.id = artist_credit_name.artist_credit
    JOIN recording
        ON recording.artist_credit = artist_credit.id
    GROUP BY  artist.id)
GROUP BY  area.name
```
***Versione B***
Commento:
Nella seconda versione eseguiamo dei join tra le opportune tabelle verificando che il tipo dell’area sia uguale a “stato” e infine facciamo la group by dei nomi dell’area.
```SQL
SELECT area.name nome_nazione,
        coalesce (sum(recording.length)/60000,
         0) somma_registrazioni
FROM ((artist_credit
JOIN recording
    ON recording.artist_credit = artist_credit.id)
JOIN artist
    ON artist_credit.id = artist.id)
JOIN area
    ON artist.area = area.id
JOIN area_type
    ON area_type.id=area.type
WHERE area_type.name = 'Country'
GROUP BY  area.name
```
**Query 13**
Richiesta:
Ricavare gli artisti britannici che hanno pubblicato almeno 10 release (il risultato deve contenere il nome
dell’artista, il nome dello stato (cioè United Kingdom) e il numero di release) (scrivere due versioni della query).
***Versione A***
Commento:
La prima versione esegue una select su due join fra le query contenenti le informazioni a noi necessarie ed in seguito filtra il risultato applicando le condizioni specificate dalla consegna.
```SQL
SELECT artist_credit.name,
        area.name,
        count(release.id)
FROM release
JOIN artist_credit
    ON release.artist_credit = artist_credit.id
JOIN artist
    ON artist_credit.id = artist.id
JOIN area
    ON artist.area = area.id
WHERE area.name = 'United Kingdom'
GROUP BY  artist_credit.name,area.name
HAVING count(release.id) >= 10
```
***Versione B***
Commento:
La prima select ossia quella esterna seleziona gli artisti con più di 10 release, di questi prende solo coloro (quindi gli artisti) che compaiono nella lista degli artisti inglesi data dalla seconda query.
```SQL
SELECT artist.name,
        count(release.id),
        area.name
FROM release
JOIN artist_credit
    ON artist_credit.id = release.artist_credit
JOIN artist_credit_name
    ON artist_credit_name.artist_credit = artist_credit.id
JOIN artist
    ON artist.id=artist_credit_name.artist
JOIN area
    ON artist.area=area.id
GROUP BY  artist.name,area.name
HAVING count(release.id)>=10
        AND artist.name in
    (SELECT artist.name
    FROM release
    JOIN artist_credit
        ON artist_credit.id = release.artist_credit
    JOIN artist_credit_name
        ON artist_credit_name.artist_credit = artist_credit.id
    JOIN artist
        ON artist.id=artist_credit_name.artist
    JOIN area
        ON artist.area=area.id
    WHERE area.name = 'United Kingdom'
            AND artist.id = release.artist_credit
    GROUP BY  artist.name,area.name)
```
**Query 14**
Richiesta:
Considerando il numero medio di tracce tra le release pubblicate su CD, ricavare gli artisti che hanno pubblicato
esclusivamente release con più tracce della media (il risultato deve contenere il nome dell’artista e il numero di
release ed essere ordinato per numero di release discendente) (scrivere due versioni della query).
***Versione A***
Commento:
La query interna trova tutti gli artisti con un numero di tracce pubblicate su CD (format =1) inferiore alla media. Quella esterna elimina da tutte le release degli artisti quelle tuple della seconda che sono appunto inferiori alla media, ottenendo quindi solo coloro che hanno pubblicato esclusivamente release con più tracce della media.
```SQL
SELECT count(release.id),
        artist_credit.name
FROM release
JOIN artist_credit
    ON release.artist_credit = artist_credit.id
JOIN medium
    ON medium.release = release.id
WHERE medium.format = 1
        AND artist_credit.name NOT IN (--Gli artisti che hanno fatto release con numero track inferiore a mediaSELECT artist_credit.name
FROM release
JOIN artist_credit
    ON release.artist_credit = artist_credit.id
JOIN medium
    ON medium.release = release.id
WHERE medium.track_count <= 
    (SELECT avg(medium.track_count)
    FROM medium
    WHERE medium.format=1) )
GROUP BY  artist_credit.name
ORDER BY  count(release.id) desc
```
***Versione B***
Commento:
Quattro sottoquery.
La prima select più interna ricava la media delle tracce delle release su cd. La 2 ricava gli artisti che hanno pubblicato release con numero tracce minore o uguale alla
media. La 3 esclude da tutti gli artisti, quelli che hanno rilascaito rilasciato un numero di release
inferiori alla media. La 4 esegue una proiezione del nome degli artisti che si trovano nella sottoquery ossia
hanno un numero di release superiore alla media.
```SQL
SELECT count(release.id),
        artist_credit.name
FROM release
JOIN artist_credit
    ON release.artist_credit = artist_credit.id
JOIN medium
    ON medium.release = release.id
WHERE medium.format = 1
        AND artist_credit.name IN (--Gli artisti che hanno fatto release con numero track maggiore a mediaSELECT artist_credit.name
FROM release
JOIN artist_credit
    ON release.artist_credit = artist_credit.id
JOIN medium
    ON medium.release = release.id exceptSELECT artist_credit.name
FROM release
JOIN artist_credit
    ON release.artist_credit = artist_credit.id
JOIN medium
    ON medium.release = release.id
WHERE medium.track_count <=
    (SELECT avg(medium.track_count)
    FROM medium
    WHERE medium.format=1)) )
GROUP BY  artist_credit.name
ORDER BY  count(release.id) desc
```
**Query 15**
Richiesta:
Ricavare il primo artista morto dopo Louis Armstrong (il risultato deve contenere il nome dell’artista, la sua data di nascita e la sua data di morte) (scrivere due versioni
della query).
***Versione A***
Commento:
Nella prima versione abbiamo 3 sottoquery dove abbiamo :
Prima select: Cerchiamo la data di nascita e di morte dell’artista tale che sia nulla.
* Seconda select: Troviamo la data di nascita immediatamente successiva a quella della terza
sottoquery.
* Terza Sottoquery: Troviamo la data di morte di Louis Armstrong.

Quindi combinando i risultati delle sottoquery abbiamo il primo artista morto dopo Louis Armstrong.
```SQL
SELECT artist.name nome_artista,
         make_date(artist.begin_date_year,
        artist.begin_date_month,
        artist.begin_date_day) AS data_nascita,
         make_date(artist.end_date_year,
        artist.end_date_month,
        artist.end_date_day) AS data_morte
FROM artist
WHERE artist.begin_date_year is NOT null
        AND artist.begin_date_month is NOT null
        AND artist.begin_date_day is NOT null
        AND artist.end_date_year is NOT null
        AND artist.end_date_month is NOT null
        AND artist.end_date_day is NOT null
        AND make_date(artist.end_date_year,artist.end_date_month,artist.end_date_day) IN 
    (SELECT min(make_date(artist.end_date_year,
        artist.end_date_month,
        artist.end_date_day))
    FROM artist
    WHERE artist.begin_date_year is NOT null
            AND artist.begin_date_month is NOT null
            AND artist.begin_date_day is NOT null
            AND artist.end_date_year is NOT null
            AND artist.end_date_month is NOT null
            AND artist.end_date_day is NOT null
            AND make_date(artist.end_date_year,artist.end_date_month,artist.end_date_day) > 
        (SELECT make_date(artist.end_date_year,
        artist.end_date_month,
        artist.end_date_day)
        FROM artist
        WHERE artist.name = 'Louis Armstrong'))
```
***Versione B***
Commento:
Nella seconda versione troviamo tutte le date di nascita e di morte dell’artista tale che siano nulle e intersechiamo il risultato con la tabella data da:
* Prima select: Cerchiamo la data di nascita e di morte dell’artista tale che sia nulla.
* Seconda Select: Troviamo la data di morte immediatamente successiva a quella della terza
sottoquery.
* Terza Sottoquery: Troviamo a data di morte di Louis Armstrong.
```SQL
SELECT artist.name nome_artista,
         make_date(artist.begin_date_year,
        artist.begin_date_month,
        artist.begin_date_day) data_nascita,
         make_date(artist.end_date_year,
        artist.end_date_month,
        artist.end_date_day) data_morte
FROM artist
WHERE artist.begin_date_year is NOT null
        AND artist.begin_date_month is NOT null
        AND artist.begin_date_day is NOT null
        AND artist.end_date_year is NOT null
        AND artist.end_date_month is NOT null
        AND artist.end_date_day is NOT NULL intersectSELECT artist.name nome_artista,
         make_date(artist.begin_date_year,
        artist.begin_date_month,
        artist.begin_date_day) AS data_nascita,
         make_date(artist.end_date_year,
        artist.end_date_month,
        artist.end_date_day) AS data_morte
FROM artist
WHERE artist.begin_date_year is NOT null
        AND artist.begin_date_month is NOT null
        AND artist.begin_date_day is NOT null
        AND artist.end_date_year is NOT null
        AND artist.end_date_month is NOT null
        AND artist.end_date_day is NOT null
        AND make_date(artist.end_date_year,artist.end_date_month,artist.end_date_day) = 
    (SELECT min(make_date(artist.end_date_year,
        artist.end_date_month,
        artist.end_date_day))
    FROM artist
    WHERE artist.begin_date_year is NOT null
            AND artist.begin_date_month is NOT null
            AND artist.begin_date_day is NOT null
            AND artist.end_date_year is NOT null
            AND artist.end_date_month is NOT null
            AND artist.end_date_day is NOT null
            AND make_date(artist.end_date_year,artist.end_date_month,artist.end_date_day) > 
        (SELECT make_date(artist.end_date_year,
        artist.end_date_month,
        artist.end_date_day)
        FROM artist
        WHERE artist.name = 'Louis Armstrong'))
```
**Query 16**
Richiesta:
Elencare le coppie di etichette discografiche che non hanno mai fatto uscire una release in comune ma hanno fatto uscire una release in collaborazione con una medesima terza etichetta (il risultato deve comprendere i nomi delle coppie di etichette discografiche) (scrivere due versioni della query).
***Versione A***
Commento:
* Nella prima select effettuiamo dei join tra release_label rinominata e label rinominata.
* Otteniamo la tabella delle release e delle case discografiche distinte che le hanno prodotte collaborando, da qui escludiamo i risultati delle sottoquery successive.
* Nella seconda select selezioniamo tutte le release distinte che si trovano nella terza sottoquery.
* Nella terza sottoquery facciamo il join tra la tabelle delle label che hanno lavorato alla stessa
release e il risultato della quarta sottoquery
* Nella quarta troviamo le label diverse che hanno prodotto la medesima release.
```SQL
SELECT DISTINCT l1.name AS name_label1,
         l2.name AS name_label2
FROM release_label r1
JOIN release_label r2 on(r1.label <> r2.label)
JOIN label l1 on(l1.id=r1.label)
JOIN label l2
    ON (l2.id=r2.label)
WHERE NOT EXISTS 
    (SELECT *
    FROM release
    WHERE release.id = r1.release
            AND r2.release =release.id)
        AND (r1.label,r2.label) IN 
    (SELECT DISTINCT r1.label AS label1,
        x.label1
    FROM release_label r1
    JOIN release_label r2 on(r1.label <>r2.label
            AND r1.release = r2.release) join
        (SELECT DISTINCT r1.label AS label1,
        r2.label AS label2
        FROM release_label r1
        JOIN release_label r2 on(r1.label <>r2.label
                AND r1.release = r2.release) )x on(x.label1<>r1.label
                AND x.label2=r2.label)
        ORDER BY  r1.label)
            AND r1.label<r2.label
```
***Versione B***
Commento:
Nella tabella label_collaboration, creata con la WITH, vengono inserite tutte le coppie di label che hanno lavorato all'uscita di una stessa release.
Nella query principale, si prendono tutte le coppie di label che non appartengono a quelle estratte da label_collaboration, quindi tutte le coppie di label che non hanno rilasciato una
release in comune. Con la query interna, si controlla se esiste una terza label che ha collaborato con entrambe.
```SQL
with label_collaboration as
    (SELECT DISTINCT r1.label AS label1,
         r2.label AS label2
    FROM release_label r1, release_label r2
    WHERE r1.release = r2.release
            AND r1.label <> r2.label )
SELECT DISTINCT l1.name AS label1,
         l2.name AS label2
FROM label l1, label l2, release_label r1, release_label r2
WHERE (l1.id, l2.id) NOT IN 
    (SELECT *
    FROM label_collaboration)
        AND l1.name <> l2.name
        AND r1.label = l1.id
        AND r2.label = l2.id
        AND exists
    (SELECT DISTINCT l3.name
    FROM label l3
    JOIN release_label r3
        ON l3.id = r3.label
    WHERE r3.release = r1.release
            AND l1.name <> l3.name
            AND l3.name in
        (SELECT DISTINCT l.name
        FROM label l
        JOIN release_label r
            ON l.id = r.label
        WHERE r.release = r2.release
                AND l.name <> l2.name))
```