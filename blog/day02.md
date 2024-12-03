# Day 02

Je me suis demandé si changer de techo à chaque journée pouvait le faire…
Finalement je suis resté avec les possibilités de DuckDB.

## Partie 1

```txt
…
```

Pas de problématique particulière pour cette première partie.
Comme la dernière fois j'ai commencé par réaliser plusieurs requêtes avec des tables intermédiaires puis j'ai transformé le tout en une seule requête.
À noter que j'ai exclu le mot clé `level` de la règle de lint `references.keywords` afin de respecter le contexte de l'énnoncé.

Requête finale : [`day02_1.sql`](../payloads/day02_1.sql).

## Partie 2

```txt
…
```

À partir de là j'ai pu utiliser la même procédure que pour la première partie et valider l'épreuve.

Requête finale : [`day02_2.sql`](../payloads/day02_2.sql).

## Bilan

Le besoin de test unitaire se confirme !

Dans la deuxième partie il y a des transformations que je répète deux fois, une pour trouver les rapports "safe" dès le départ et une seconde fois pour contrôler les rapports avec la tolérance.
J'ai utilisé une macro mais pas plus. Il aurait été intéressant de définir dynamiquement la création d'une table.
