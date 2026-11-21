{-#LANGUAGE GADTs #-}
{-# OPTIONS_GHC -fno-warn-tabs #-}

module FS where 

import Prelude

-- Nombre: Estudiante 1
-- Número: Estudiante 1

-- Nombre: Estudiante 2
-- Número: Estudiante 2

---------
--DATAS--
---------

type Nombre = String 

data Ext where { Txt::Ext ; Mp3::Ext ; Jar::Ext ; Doc::Ext ; Hs::Ext }
  deriving (Eq, Show)


data FS where {  A :: (Nombre,Ext) -> FS;
                 C :: Nombre -> [FS] -> FS }
  deriving (Eq, Show)
	
  
--------------
--EJERCICIOS--
--------------

-- 1
cjazz :: FS 
cjazz = C "jazz" [A ("mumbles", Mp3)]

crock :: FS 
crock = C "rock" [ A ("clones", Mp3), A ("bajan", Mp3), A ("clara", Mp3)]

cmusica :: FS
cmusica = C "musica" [cjazz, crock, A ("clara", Mp3)]


-- Completar el resto de los componentes del FS

cort :: FS
cort = C "ort" [cobls,A("notas",Txt)]

cobls :: FS
cobls = C "obls" [A("p2",Txt),A("p2",Jar),A("fc",Hs)]

csys :: FS
csys = C "sys" [A("sys",Txt), C "sys" []]

craiz :: FS
craiz = C "raiz" [cmusica, A("notas",Txt), cort, csys]

----
ext_munuscula :: Ext -> String
ext_munuscula = \ e -> case e of{
  Txt-> "txt";
  Mp3 -> "mp3";
  Jar -> "jar";
  Doc -> "doc";
  Hs -> "hs";
  -- _ -> "unknown" no es necesario
}

-- 2
nombre :: FS -> Nombre
nombre = \ fs -> case fs of {
  A(nombre, ext) -> nombre ++ "." ++ (ext_munuscula ext);
  C s l -> s
}

----
-- 3
contenido :: FS -> [Nombre]
contenido = \ fs -> case fs of {
  A(n,e) -> error "no es una carpeta";
  C s l -> case l of {
    [] -> [];
    x:xs -> (nombre x):(contenido (C "aux" xs))      -- Esta bien asi o es una chanchada?
  }
}

----
-- 4
cantA :: FS -> Int 
cantA = \ fs -> case fs of {
  A(n,e) -> 1;
  C s l -> case l of {
    [] -> 0;
    x :xs -> case x of{
      A(n2,e2) -> 1 + cantA (C "aux" xs);  -- Esta bien asi o es una chanchada?
      C s l -> cantA (C s l)+cantA (C "aux" xs)      -- Esta bien asi o es una chanchada?
    }
  }
}

----
-- 5

-- La búsqueda de archivos usa el nombre sin la extensión.
pertenece :: Nombre -> FS -> Bool
pertenece = \ n fs -> case fs of {
  A(s, _) -> n == s;
  C s l -> n == s || perteneceLista n l
}

perteneceLista :: Nombre -> [FS] -> Bool
perteneceLista = \ n l -> case l of {
  [] -> False;
  x : xs -> pertenece n x || perteneceLista n xs
}
----
-- 6

valido :: FS -> Bool
valido = \ fs -> case fs of {
  A(_, _) -> True;
  C _ l -> validoLista l
}

-- Los conflictos se buscan entre hermanos. valido x revisa el interior de cada hijo.
validoLista :: [FS] -> Bool
validoLista = \ l -> case l of {
  [] -> True;
  x : xs -> sinConflictoConLista x xs && valido x && validoLista xs
}

sinConflictoConLista :: FS -> [FS] -> Bool
sinConflictoConLista = \ x l -> case l of {
  [] -> True;
  y : ys -> sinConflicto x y && sinConflictoConLista x ys
}

sinConflicto :: FS -> FS -> Bool
sinConflicto = \ x y -> case (x, y) of {  
  (A(n1, e1), A(n2, e2)) -> n1 /= n2 || e1 /= e2;
  (C s1 _, C s2 _) -> s1 /= s2;
  _ -> True
}

----
-- 7
archivosExt :: Ext -> FS -> [Nombre]
archivosExt = \ ext fs -> case fs of {
  A(s, e) -> case ext == e of {
      True -> [s];
      False -> []
    };
  C _ l -> archivosExtLista ext l
}

archivosExtLista :: Ext -> [FS] -> [Nombre]
archivosExtLista = \ ext l -> case l of {
    [] -> [];
    x : xs -> archivosExt ext x ++ archivosExtLista ext xs
};

----
-- 8
cambiarNom :: Nombre -> Nombre -> FS -> FS 
cambiarNom =  \ viejo nuevo fs -> case fs of {
  A (s, e) -> case s == viejo of {
    True -> A (nuevo, e);
    False -> A (s, e)
  };
  C s l -> case s == viejo of {
    True -> C nuevo (cambiarNomLista viejo nuevo l);
    False -> C s (cambiarNomLista viejo nuevo l)
  }
}

cambiarNomLista :: Nombre -> Nombre -> [FS] -> [FS]
cambiarNomLista = \ viejo nuevo l -> case l of {
  [] -> [];
  x : xs -> cambiarNom viejo nuevo x : cambiarNomLista viejo nuevo xs
}

----
-- 9
nivelesC :: FS -> Int
nivelesC = \ fs -> case fs of {
  A (_, _) -> 0;
  C _ l -> case l of {
    [] -> 1;
    x : xs -> 1 + max (nivelesC x) (nivelesCLista xs)
  }
}

nivelesCLista :: [FS] -> Int
nivelesCLista = \ l -> case l of {
  [] -> 0;
  x : xs -> max (nivelesC x) (nivelesCLista xs)
}

----
-- 10
borrar :: Nombre -> FS -> FS 
borrar = undefined
----
-- 11
ordenar :: FS-> FS
ordenar = undefined

-------
--FIN--
-------