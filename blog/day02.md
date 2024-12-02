# Day 02

Je me suis demandé si changer de techo à chaque journée pouvait le faire…
Finalement je suis resté avec les possibilités de DuckDB.

## Partie 1

```txt
--- Day 2: Red-Nosed Reports ---

Fortunately, the first location The Historians want to search isn't a long walk from the Chief Historian's office.

While the Red-Nosed Reindeer nuclear fusion/fission plant appears to contain no sign of the Chief Historian, the engineers there run up to you as soon as they see you. Apparently, they still talk about the time Rudolph was saved through molecular synthesis from a single electron.

They're quick to add that - since you're already here - they'd really appreciate your help analyzing some unusual data from the Red-Nosed reactor. You turn to check if The Historians are waiting for you, but they seem to have already divided into groups that are currently searching every corner of the facility. You offer to help with the unusual data.

The unusual data (your puzzle input) consists of many reports, one report per line. Each report is a list of numbers called levels that are separated by spaces. For example:

7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
This example data contains six reports each containing five levels.

The engineers are trying to figure out which reports are safe. The Red-Nosed reactor safety systems can only tolerate levels that are either gradually increasing or gradually decreasing. So, a report only counts as safe if both of the following are true:

The levels are either all increasing or all decreasing.
Any two adjacent levels differ by at least one and at most three.
In the example above, the reports can be found safe or unsafe by checking those rules:

7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.
So, in this example, 2 reports are safe.

Analyze the unusual data from the engineers. How many reports are safe?
```

Pas de problématique particulière pour cette première partie.
Comme la dernière fois j'ai commencé par réaliser plusieurs requêtes avec des tables intermédiaires puis j'ai transformé le tout en une seule requête.
À noter que j'ai exclu le mot clé `level` de la règle de lint `references.keywords` afin de respecter le contexte de l'énnoncé.

Requête finale : [`day02_1.sql`](../payloads/day02_1.sql).

## Partie 2

```txt
--- Part Two ---

The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.

The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report. It's like the bad level never happened!

Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.

More of the above example's reports are now safe:

7 6 4 2 1: Safe without removing any level.
1 2 7 8 9: Unsafe regardless of which level is removed.
9 7 6 2 1: Unsafe regardless of which level is removed.
1 3 2 4 5: Safe by removing the second level, 3.
8 6 4 4 1: Safe by removing the third level, 4.
1 3 6 7 9: Safe without removing any level.
Thanks to the Problem Dampener, 4 reports are actually safe!

Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?
```

La seconde partie a été… compliquée.
J'ai d'abord souhaité repartir de la partie 1 et ajouter un compteur de "joker".
J'ai obtenu un résultat qui fonctionnait avec le dataset de l'énnoncé mais pas avec le dataset de valdiation.
J'ai alors ajouté des cas au dataset de test : dans un premier temps `8 6 7 6 5` puis dans un second `8 3 7 6 5`.
Je n'ai alors pas été en mesure de satifsaire tous mes cas de tests.

J'ai décidé de repartir de l'énnoncé initial et revoir ma stratégie.
Une intution de traiter le problème en gardant les listes m'a fait lire cette partie de la documentation de DuckDB.
J'ai alors réalisé une deuxième version du code pour la première partie : [`day02_1B.sql`](../payloads/day02_1B.sql).
À partir de celle-ci j'ai pu avancer pour la partie 2 de l'épreuve.
La logique a été de créer d'avoir une ligne pour chaque niveau d'un rapport et à chaque ligne le rapport sans l'élément de la ligne.
Par exemple pour le rapport `1 3 2 4 5` je souhaite obtenir les lignes suivantes :
```
3 2 4 5
1 2 4 5
1 3 4 5
1 3 2 5
1 3 2 4
```
À partir de là j'ai pu utiliser la même procédure que pour la première partie et valider l'épreuve.

Requête finale : [`day02_2.sql`](../payloads/day02_2.sql).

## Bilan

Le besoin de test unitaire se confirme !

Dans la deuxième partie il y a des transformations que je répète deux fois, une pour trouver les rapports "safe" dès le départ et une seconde fois pour contrôler les rapports avec la tolérance.
J'ai utilisé une macro mais pas plus. Il aurait été intéressant de définir dynamiquement la création d'une table.
