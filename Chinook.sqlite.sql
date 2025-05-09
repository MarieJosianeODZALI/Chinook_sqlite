-- Sélectionner des données: Selectionner toute la table artiste 
SELECT * FROM Artist ;



-- Sélectionner le nom de l’artiste et son ArtistId de la table Artist, mais seulement pour les 10 premiers résultats

SELECT * FROM Artist LIMIT 10;



-- Trouver les 5 premiers albums de la table Album triés par AlbumId de manière décroissante

SELECT * FROM Album 
ORDER BY AlbumId DESC 
LIMIT 5;



-- Filtrage avec WHERE: Sélectionner tous les albums dont le titre contient "love" (sans tenir compte de la casse)

SELECT *
FROM Album
WHERE Title LIKE '%Love%';



-- Trouver les artistes qui ont plus de 5 albums dans la table Album (utilise GROUP BY et HAVING)

SELECT ArtistId, COUNT(*) AS AlbumCount
FROM Album
GROUP BY ArtistId
HAVING COUNT(*) > 5;


-- Jointures entre tables: Récupérer tous les artistes avec leurs albums. Utilise une jointure INNER JOIN entre les tables Artist et Album

SELECT Ar.ArtistId, Ar.Name, Al.AlbumId, Al.Title
From Artist Ar
Join Album Al
	On Ar.ArtistId = Al.ArtistId ;


-- Jointures entre tables: Récupérer la liste des artistes avec le nom de l'album et la TrackId de chaque chanson dans l'album, 
-- en effectuant des jointures entre Artist, Album et Track

SELECT Ar.ArtistId, Ar.Name, Al.AlbumId, Al.Title, Tr.TrackId
from Artist Ar
Join Album Al 
	On Ar.ArtistId = Al.ArtistId 
join Track Tr
	On Al.AlbumId = Tr.AlbumId ;


-- Agrégation de données: Trouver l'album qui a le plus de morceaux dans la table Track. Utilise GROUP BY et ORDER BY

SELECT AlbumId, count(*) AS Trackcount
from Track 
Group BY AlbumId 
Order by Trackcount desc
Limit 1;


-- Sous-requêtes: Trouver tous les albums dont le nombre de morceaux est supérieur à la moyenne des morceaux par album

-- A -- Trouver les albums avec un nombre de morceaux > moyenne

SELECT AlbumId
FROM Track
GROUP BY AlbumId
HAVING COUNT(*) > -- (moyenne calculée ci-dessous)


-- B -- calcul du nombre de chaque Track

SELECT COUNT(*) AS TrackCount
 FROM Track
 GROUP BY AlbumId;


-- C -- calcul de la moyenne des trackcount

SELECT AVG(TrackCount) 
FROM (
  SELECT COUNT(*) AS TrackCount
  FROM Track
  GROUP BY AlbumId);


-- Resultat final de la sous requête

SELECT Title
FROM Album
WHERE AlbumId IN (
  SELECT AlbumId
  FROM Track
  GROUP BY AlbumId
  HAVING COUNT(*) > (SELECT AVG(TrackCount) FROM (
    SELECT COUNT(*) AS TrackCount
    FROM Track
    GROUP BY AlbumId))
);


-- Création de vues : Créer une vue qui retourne les artistes et 
-- leurs albums avec le nombre total de morceaux pour chaque album

Create view ArtistAlbumTrack AS
SELECT Ar.Name, Al.Title, COUNT(T.TrackId) AS Trackcount
From Artist Ar
Join Album Al
	On Ar.ArtistId = Al.ArtistId
Join Track T
	on Al.AlbumId = T.AlbumId
Group by Ar.Name, Al.Title; 


-- Requête complexe: Trouver les 5 artistes ayant vendu le plus d'exemplaires 
-- (en utilisant les tables Invoice et InvoiceLine). Utilise une jointure entre plusieurs tables

SELECT Ar.name , SUM(Il.quantity) AS Totalsales
from Artist Ar
join Album Al
	on Ar.ArtistId = Al.ArtistId
Join Track T 
	on Al.AlbumId = T.AlbumId
join InvoiceLine Il
	on T.TrackId = Il.TrackId
Group by Ar.Name
ORDER by Totalsales  desc
Limit 5;



-- Optimisation des requêtes: Optimise une requête qui retourne tous les albums dont le titre contient "love" 
-- (en utilisant un index ou en réécrivant la requête plus efficacement) 


-- Créer l'index une seule fois
CREATE INDEX idx_album_title ON Album(Title);

-- Requête optimisée
SELECT * FROM Album
WHERE Title LIKE 'Love%';



-- Cette requête ne peut pas profiter d’un index standard, car elle commence par un joker %
-- Le % au début oblige MySQL à scanner toutes les lignes, donc l’index ne sert à rien ici
-- Ce % au début empêche l'utilisation de l'index

SELECT * FROM Album WHERE Title LIKE '%Love%';








