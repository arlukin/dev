/*
 * hash.c - Generell modul för hashtabell.
 * Använder extern kedjning.
 */

#include <stdio.h>
#include <stdlib.h>
#include "hash.h"

/*
 * Noderna i "hinkarna".
 */

struct hashnode
{
    void              *el;
    struct hashnode   *next;
};
typedef struct hashnode    hashnode;

/*
 * Själva hashtabellen.
 */

struct hashtab
{
    int           size;
    int           cardinal;
    hash_f        hashfun;
    hash_cmp_f    cmp;
    hashnode    **vec;
};

#define HASH(tab, el)   ((tab)->hashfun (el, (tab)->size))


/*
 * Förberäknade primtal för att snabba upp make_prime.
 */

static int   primes[] =
{ 11, 23, 47, 97, 197, 307, 617, 1237,
  2477, 4957, 9923, 19853, 39709, 79423,
  158849, 317701, 635413, 1270849,
  2541701, 5083423 };


/*
 * make_prime
 *  Returnerar ett primtal >= num.
 */

static int
make_prime (
    int   num)
{
    int   i;

    for (i = 0;
         i < sizeof (primes) / sizeof (int) - 1 && primes[i] < num;
         ++i)
        ;
    return primes[i];
}

/*
 * hashtab_new
 *  Returnerar en nyskapad, tom hashtabell som använder hashfun som
 *  hashfunktion och cmp för elementjämförelse.
 */

hashtab *
hash_new (
    int            size,
    hash_f         hashfun,
    hash_cmp_f     cmp)
{
    hashtab       *htab;
    int            i;

    size = make_prime (size);
    htab = new hashtab[sizeof (*htab)];
    if (htab == NULL)
        return NULL;
    htab->vec = (hashnode **)new hashnode[(size * sizeof (hashnode *))];
    if (htab->vec == NULL)
    {
        delete (htab);
        return NULL;
    }
    htab->size = size;
    htab->cardinal = 0;
    htab->hashfun = hashfun;
    htab->cmp = cmp;
    for (i = 0; i < size; ++i)
        htab->vec[i] = NULL;

    return htab;
}

/*
 * hash_free
 *  Frigör hashtabellen htab.
 */

void
hash_free (
    hashtab    *htab)
{
    int         i;
    hashnode   *cur;
    hashnode   *next;

    for (i = 0; i < htab->size; ++i)
    {
        cur = htab->vec[i];
        while (cur != NULL)
        {
            next = cur->next;
            delete (cur);
            cur = next;
        }
    }
    delete (htab->vec);
    delete (htab);
}

/*
 * restructure
 *  Omstrukturerar hashtabellen htab. Om detta inte är möjligt av
 *  allokeringsskäl lämnas tabellen som den var.
 */

static void
restructure (
    hashtab    *htab)
{
    hashtab    *ntab = NULL;
    hashnode   *cur;
    hashnode  **tmpvec;
    int         i;
    int         factor;
    int         tmpsize;

    for (factor = 8; ntab == NULL && factor > 1; factor /= 2)
        ntab = hash_new (factor * htab->size,
                         htab->hashfun,
                         htab->cmp);
    if (ntab == NULL)
        return;

    for (i = 0; i < htab->size; ++i)
    {
        cur = htab->vec[i];
        while (cur != NULL)
        {
            if (hash_insert (cur->el, ntab) != 0)
            {
                hash_free (ntab);
                return;
            }
            cur = cur->next;
        }
    }
    tmpvec = htab->vec;
    tmpsize = htab->size;
    htab->vec = ntab->vec;
    htab->size = ntab->size;
    ntab->vec = tmpvec;
    ntab->size = tmpsize;
    hash_free (ntab);
}

/*
 * hash_insert
 *  Sätter in elementet el i hashtabellen htab. Vid behov sker en
 *  omstrukturering. Returnerar 0 om insättningen lyckades, 1 annars.
 */

int
hash_insert (
    void       *el,
    hashtab    *htab)
{
    int         i;
    hashnode   *hnode;

    ++htab->cardinal;
    if (htab->cardinal > htab->size * 10)
    {
        restructure (htab);
    }
    hnode = new hashnode[sizeof (*hnode)];
    if (hnode == NULL)
        return 1;

    i = HASH (htab, el);
    hnode->next = htab->vec[i];
    hnode->el = el;
    htab->vec[i] = hnode;
    return 0;
}

/*
 * find_elem
 *  Hjälpfunktion till hash_search och hash_remove. Returnerar en
 *  pekare till pekaren till det sökta elementets nod, en pekare till
 *  NULL om detta inte finns.
 */

static hashnode **
find_elem (
    void        *el,
    hashtab     *htab)
{
    hashnode   **hnode_ptr;

    hnode_ptr = &htab->vec[HASH (htab, el)];
    while (*hnode_ptr != NULL
        && htab->cmp ((*hnode_ptr)->el, el) != 0)
    {
        hnode_ptr = &(*hnode_ptr)->next;
    }
    return hnode_ptr;
}


/*
 * hash_search
 *  Returnerar ett element lika med el i htab om något
 *  sådant finns, annars NULL.
 */

void *
hash_search (
    void        *el,
    hashtab     *htab)
{
    hashnode   **hnode_ptr;

    hnode_ptr = find_elem (el, htab);
    if (*hnode_ptr == NULL)
        return NULL;
    else
        return (*hnode_ptr)->el;
}


/*
 * hash_remove
 *  Tar bort något element lika med el ur htab. Returnerar det
 *  borttagna elementet, eller NULL om inget sådant fanns.
 */

void *
hash_remove (
    void        *el,
    hashtab     *htab)
{
    hashnode   **hnode_ptr;
    hashnode    *remove;
    void        *ret_el;

    hnode_ptr = find_elem (el, htab);
    if (*hnode_ptr == NULL)
        return NULL;

    ret_el = (*hnode_ptr)->el;
    remove = *hnode_ptr;
    *hnode_ptr = (*hnode_ptr)->next;
    delete (remove);
    --htab->cardinal;

    return ret_el;
}


/*
 * hash_cardinal
 *  Returnerar antalet element i tabellen htab.
 */

int
hash_cardinal (
    hashtab   *htab)
{
    return htab->cardinal;
}


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
    hashtab       *htab)
{
    int            i;
    hashnode      *hnode;

    for (i = 0; i < htab->size; ++i)
        for (hnode = htab->vec[i]; hnode != NULL; hnode = hnode->next)
            proc (hnode->el);
}
