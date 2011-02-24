/*
 * hash.h - Generell modul f�r hashtabell.
 */
typedef struct hashtab   hashtab;

typedef int   (*hash_f) (void *, int);
typedef int   (*hash_cmp_f) (void *, void *);
typedef void  (*hash_iter_f) (void *);


/*
 * hashtab_new
 *  Returnerar en nyskapad, tom hashtabell som anv�nder hashfun som
 *  hashfunktion och cmp f�r elementj�mf�relse.
 */

hashtab *
hash_new (
    int           size,
    hash_f        hashfun,
    hash_cmp_f    cmp);


/*
 * hash_free
 *  Frig�r hashtabellen htab.
 */

void
hash_free (
    hashtab   *htab);


/*
 * hash_insert
 *  S�tter in el i tabellen htab. Returnerar 1 om ins�ttningen
 *  misslyckas, 0 annars.
 */

int
hash_insert (
    void      *el,
    hashtab   *htab);


/*
 * hash_search
 *  Returnerar ett element lika med el i htab om n�got
 *  s�dant finns, annars NULL.
 */

void *
hash_search (
    void      *el,
    hashtab   *htab);


/*
 * hash_remove
 *  Tar bort n�got element lika med el ur htab. Returnerar det
 *  borttagna elementet, eller NULL om inget s�dant fanns.
 */

void *
hash_remove (
    void      *el,
    hashtab   *htab);


/*
 * hash_cardinal
 *  Returnerar antalet element i tabellen htab.
 */

int
hash_cardinal (
    hashtab   *htab);


/*
 * hash_for_each
 *  Anropar proc med vart och ett av de lagrade elementen i htab.
 *  Om proc �ndrar i elementen s� att hashfunktionen inte l�ngre
 *  ger samma v�rde som tidigare �r den enda till�tna operationen
 *  p� tabellen efter detta hash_free.
 */

void
hash_for_each (
    hash_iter_f    proc,
    hashtab       *htab);
