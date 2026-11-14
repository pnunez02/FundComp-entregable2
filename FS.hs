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
cort = C "ort" [cobls,A("Notas",Txt)]

cobls :: FS
cobls = C "obls" [A("p2",Txt),A("p2",Jar),A("fc",Hs)]

csys :: FS
csys = C "sys" [A("sys",Txt), C "sys" []]

craiz :: FS
craiz = C "raiz" [cmusica, A("Notas",Txt), cort, csys]

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
pertenece :: Nombre -> FS -> Bool 
pertenece = undefined
----
-- 6
valido :: FS -> Bool
valido = undefined
----
-- 7
archivosExt :: Ext -> FS -> [Nombre]
archivosExt = undefined
----
-- 8
cambiarNom :: Nombre -> Nombre -> FS -> FS 
cambiarNom = undefined		
----
-- 9
nivelesC :: FS -> Int
nivelesC = undefined	
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