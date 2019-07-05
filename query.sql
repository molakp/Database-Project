--1
select count(distinct language) as Numero_Lingue
from release
--2
select artist.name as Nome_artista,language.name as Lingua_canzone
from artist,language
where language.name = 'Italiano'
-- 3
select name
from release
where language is NULL
-- 4
select artist.name
from artist
where artist.name like '%a%'
and artist.name like '%e%'
and artist.name like '%i%'
and artist.name like '%o%'
and artist.name like '%u%'
and artist.name not like '% %'

--5
select sort_name,name,type
from artist
where name like '%Prince%'
--6

select distinct artist.name, release.name
from artist,release,area join area_type on (area.type = area_type.id)
where area_type.id = '1' and area.name = 'United Kingdom'
and artist.ended <> 'true' and release.artist_credi t = artist.id
order by artist.name ASC

--7
select distinct artist_credit.name,artist.name,release.name
from ((artist_credit join artist_credit_name
on artist_credit_name.artist_credit = artist_credit.id)
join artist on artist_credit_name.artist = artist.id)
join release on(release.artist_credit = artist_credit.id)
where artist_credit.name <> artist.name

--8
select artist.name,count(release.name)
from ((artist_credit join artist_credit_name
on artist_credit_name.artist_credit = artist_credit.id)
join artist on artist_credit_name.artist = artist.id)
join release on(release.artist_credit = artist_credit.id)
group by artist.name
having count(release.name) <3

--9
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

--10
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

--11
select distinct language.name,count (distinct release.id)
from language left join release on (release.language=language.id)
group by language.name
except
select language.name,count (distinct release.id)
from language,release
where language.id=release.language
group by language.name

--12
select distinct language.name,count (distinct release.id)
from language left join release on (release.language = language.id)
where release.id is null
group by language.name

--13

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

--14
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
--15

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

--16

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

--17

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

--18
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

--19

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

--20

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

--21

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
--22

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

--23
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
--24
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

