/*
 * hash.h - Generell modul för hashtabell.
 */
typedef struct hashtab   hashtab;

typedef int   (*hash_f) (void *, int);
typedef int   (*hash_cmp_f) (void *, void *);
typedef void  (*hash_iter_f) (void *);


/*
 * hashtab_new
 *  Returnerar en nyskapad, tom hashtabell som använder hashfun som
 *  hashfunktion och cmp för elementjämförelse.
 */

hashtab *
hash_new (
    int           size,
    hash_f        hashfun,
    hash_cmp_f    cmp);


/*
 * hash_free
 *  Frigör hashtabellen htab.
 */

void
hash_free (
    hashtab   *htab);


/*
 * hash_insert
 *  Sätter in el i tabellen htab. Returnerar 1 om insättningen
 *  misslyckas, 0 annars.
 */

int
hash_insert (
    void      *el,
    hashtab   *htab);


/*
 * hash_search
 *  Returnerar ett element lika med el i htab om något
 *  sådant finns, annars NULL.
 */

void *
hash_search (
    void      *el,
    hashtab   *htab);


/*
 * hash_remove
 *  Tar bort något element lika med el ur htab. Returnerar det
 *  borttagna elementet, eller NULL om inget sådant fanns.
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
 *  Om proc ändrar i elementen så att hashfunktionen inte längre
 *  ger samma värde som tidigare är den enda tillåtna operationen
 *  på tabellen efter detta hash_free.
 */

void
hash_for_each (
    hash_iter_f    proc,
    hashtab       *htab);
