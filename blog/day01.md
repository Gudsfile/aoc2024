# Day 01

Premier Advent Of Code pour moi.

En lisant le premier énnoncé je me suis dis que c'était une bonne occasion pour découvrir les fonctionnalités qu'offre DuckDB.

## Partie 1

```txt
…
```

J'ai commencé pas à pas en créant des tables en mémoire à chaque étape.
Par la suite j'ai regroupé les parties en une requêtes avec des CET pour plus de clarté.

Mes premières requêtes avant [`day01_1.sql`](../payloads/day01_1.sql) :
```sql
D create table list1 as (select split_part(lists, '   ', 1) as l1 from read_csv('datasets/day01.txt', header=false, columns={'lists': 'TEXT'}));
D create table list2 as (select split_part(lists, '   ', 2) as l2 from read_csv('datasets/day01.txt', header=false, columns={'lists': 'TEXT'}));
D create table ranked_list1 as (select row_number() OVER (ORDER BY l1) as rank, l1 from list1);
D create table ranked_list2 as (select row_number() OVER (ORDER BY l2) as rank, l2 from list2);
D create table distance_between_lists as (select abs(l1::INTEGER - l2::INTEGER) as distance from ranked_list1 join ranked_list2 using(rank));
D select sum(distance) from distance_between_lists;
┌──────┐
│ distance │
│  int128  │
├──────┤
│ XXXXXXXX │
└──────┘
```

## Partie 2

```txt
…
```

Même idée que pour la première partie.

Mes premières requêtes avant [`day01_2.sql`](../payloads/day01_2.sql) :

```sql
D create table hits_list2 as (select count(l2) as hits, l2 from list2 group by l2);
D create table similarity_between_lists as (select list1.l1::INTEGER * coalesce(hits_list2.hits,0)  as similarity from list1 left join hits_list2 on list1.l1=hits_list2.l2);
D select sum(similarity) from similarity_between_lists;
┌───────┐
│ similarity │
│   int128   │
├───────┤
│ XXXXXXXXXX │
└───────┘
```

## Bilan

J'aurai aimé pouvoir tester unitairement mes requêtes, c'est un élément que je souhaiterais trouver d'ici la fin de l'AOC.

J'en ai profitié pour ajouter une CI afin de lancer `sqlfluff`, un linter sql configuré dans le `pyproject.toml`.
