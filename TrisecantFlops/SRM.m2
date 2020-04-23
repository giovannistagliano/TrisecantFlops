
needsPackage "Resultants";

symb := "x";

SpecialRationalMap = new Type of RationalMap;

specialRationalMap = method();

specialRationalMap (List) := (l) -> (
   --
   -- phi:X-->Y,
   -- Phi:X'-->Y an extension of phi, 
   -- j:X-->X' embedding,
   -- j':X'-->X'' embedding (generally X' == X''),
   -- p:T-->S\subset X' parameterization of the special base locus S (generally T == PP^2),
   -- Phi and phi are defined by linear systems of hypersurfaces of degree d having points of multiplicity e along S.
   -- 
   try (
      (phi,Phi,j,j',p,d,e) := toSequence l;
      phi = fit phi;
      Phi = fit Phi;
      j = fit j;
      j' = fit j';
      p = fit p;
      fit(Phi,target phi);
      fit(source phi,j);
      fit(j,source Phi);
      fit(source Phi,j');
      fit(p,source Phi);
      assert(
         instance(phi,RationalMap) and 
         instance(Phi,RationalMap) and 
         ambient source phi === ambient source Phi and
         target phi === target Phi and 
         instance(j,RationalMap) and 
         source j === source phi and
         target j === source Phi and 
         instance(j',RationalMap) and 
         source j' === source Phi and 
         instance(p,RationalMap) and 
         target p === source Phi and
         instance(d,ZZ) and 
         d > 0 and 
         d == max flatten degrees ideal compress matrix Phi and 
         d == max flatten degrees ideal compress matrix phi and 
         instance(e,ZZ) and
         e > 0
       );
   ) else error "invalid data found when processing input";
   psi := new SpecialRationalMap from phi;
   psi#"rationalMap" = phi;
   psi#"extension" = Phi;
   psi#"embedding" = j;
   psi#"embedding2" = j';
   psi#"specialBaseLocus" = p;
   psi#"degreeForms" = d;
   psi#"multiplicity" = e;
   psi#"inverse" = null;
   return psi;
);

specialRationalMap (RationalMap,RationalMap,ZZ,ZZ) := (phi,p,d,e) -> (
   i := identityMap source phi;
   specialRationalMap {phi,phi,i,i,p,d,e}
);

specialRationalMap (RationalMap,Ideal,ZZ,ZZ) := (phi,S,d,e) -> (
  try assert(ring S === ambient source phi and isHomogeneous S and isSubset(ideal source phi,S)) else error "invalid data found when processing input";
  ringS := (ring S)/S;
  p := (rationalMap rationalMap map(ringS,ringS))||(source phi);
  image p;
  specialRationalMap(phi,p,d,e)
);

specialRationalMap (RationalMap,ZZ,ZZ) := (p,d,e) -> (
   specialRationalMap(rationalMap(image p,d,e),p,d,e)
);

specialRationalMap (Ideal,ZZ,ZZ) := (S,d,e) -> (
   specialRationalMap(rationalMap(S,d,e),S,d,e)
);

fit = method();

fit (RationalMap) := (phi) -> (
   K := coefficientRing phi;
   n := phi#"dimAmbientTarget";
   m := phi#"dimAmbientSource";
   Pn := Grass(0,n,K,Variable=>symb);
   Pm := Grass(0,m,K,Variable=>symb);
   if ambient source phi === Pn and ambient target phi === Pm then phi else sub(phi,Pn,Pm)
);

fit (Ring,RationalMap) := (R,phi) -> (
   if R === source phi then return phi;
   try assert(ambient R === ambient source phi and ideal R === ideal source phi) else error "invalid data found when processing input";
   phi#"map" = map(R,target phi,lift(matrix phi,ambient R));
   if phi#"maps" =!= null then phi#"maps" = apply(phi#"maps",f -> map(R,target phi,lift(matrix f,ambient R)));
   psi := phi#"inverseRationalMap";
   if psi =!= null then (
       psi#"map" = map(source psi,R,matrix psi);
       if psi#"maps" =!= null then psi#"maps" = apply(psi#"maps",f -> map(source psi,R,matrix f));
       if psi#"idealImage" =!= null then psi#"idealImage" = sub(psi#"idealImage",R);
   );
   phi
);

fit (RationalMap,Ring) := (phi,S) -> (
   if S === target phi then return phi;
   try assert(ambient S === ambient target phi and ideal S === ideal target phi) else error "invalid data found when processing input";
   phi#"map" = map(source phi,S,matrix phi);
   if phi#"maps" =!= null then phi#"maps" = apply(phi#"maps",f -> map(source phi,S,matrix f));
   if phi#"idealImage" =!= null then phi#"idealImage" = sub(phi#"idealImage",S);
   psi := phi#"inverseRationalMap";
   if psi =!= null then (
       psi#"map" = map(S,target psi,lift(matrix psi,ambient S));
       if psi#"maps" =!= null then psi#"maps" = apply(psi#"maps",f -> map(S,target psi,lift(matrix f,ambient S)));
   );
   phi
);

Ring @@ RationalMap := (R,phi) -> fit(R,phi);

RationalMap @@ Ring := (phi,S) -> fit(phi,S);

rationalMap (SpecialRationalMap) := o -> (psi) -> psi#"rationalMap";

extend (SpecialRationalMap) := o -> (phi) -> (
   -- if phi#"extension" === phi#"rationalMap" or dim source phi#"embedding" == dim target phi#"embedding" then error "not able to extend rational map";
   if phi#"extension" === phi#"rationalMap" then return phi;
   psi := new SpecialRationalMap from phi#"extension";
   psi#"rationalMap" = phi#"extension";
   psi#"extension" = psi#"rationalMap";
   psi#"embedding" = identityMap source psi#"rationalMap"; 
   psi#"embedding2" = phi#"embedding2";
   psi#"specialBaseLocus" = phi#"specialBaseLocus";
   psi#"degreeForms" = phi#"degreeForms";
   psi#"multiplicity" = phi#"multiplicity";
   psi#"inverse" = null;
   return psi;
);

inverse (SpecialRationalMap) := (psi) -> (
   if psi#"inverse" =!= null then return psi#"inverse" else (
         <<"--warning: data of inverse map not found -- this computation will take a lot of time"<<endl;
         return inverse rationalMap psi;
   );
);

inverseMap (SpecialRationalMap) := o -> (psi) -> (
   if psi#"inverse" =!= null then return psi#"inverse" else (
        <<"--warning: data of inverse map not found -- this computation will take a lot of time"<<endl;
        return inverseMap(rationalMap psi,MathMode=>o.MathMode,BlowUpStrategy=>o.BlowUpStrategy,Verbose=>o.Verbose);
   );
);

toExternalString0 = method();

toExternalString0 (SpecialRationalMap) := (psi) -> (
   str := "(o -> (specialRationalMap{"|newline;
   str = str|toExternalString(psi#"rationalMap")|","|newline;
   str = str|toExternalString(psi#"extension")|","|newline;
   str = str|toExternalString(psi#"embedding")|","|newline;
   str = str|toExternalString(psi#"embedding2")|","|newline;
   str = str|toExternalString(psi#"specialBaseLocus")|","|newline;
   str = str|toString(psi#"degreeForms")|","|newline;
   str = str|toString(psi#"multiplicity")|"}))()";
   str
);

toExternalString (SpecialRationalMap) := (psi) -> (
   if psi#"inverse" === null then return toExternalString0 psi;
   str := "(i -> ("|newline;
   str = str|"psi1 := "|toExternalString0(psi)|";"|newline;
   str = str|"psi2 := "|toExternalString0(psi#"inverse")|";"|newline;
   str = str|"(target psi1) @@ psi2; psi2 @@ (source psi1); (source psi2) @@ psi2#\"embedding\"; psi2#\"extension\" @@ (target psi2); (target psi2#\"embedding\") @@ psi2#\"extension\";"|newline;
   str = str|"psi1#\"inverse\" = psi2; psi2#\"inverse\" = psi1;"|newline;
   str = str|"psi1))()";
   str
);

forceInverseMap (SpecialRationalMap,SpecialRationalMap) := (psi1,psi2) -> (
   if (psi1#"rationalMap")#"inverseRationalMap" =!= psi2#"rationalMap" then error "failed to declare an inverse rational map";
   if (psi1#"inverse" =!= null or  psi2#"inverse" =!= null) then error "not permitted to reassign inverse rational map";
   psi1#"inverse" = psi2;
   psi2#"inverse" = psi1;
);

specialBaseLocus = method();

specialBaseLocus (SpecialRationalMap) := (psi) -> image psi#"specialBaseLocus";

parametrizeSpecialBaseLocus = method();

parametrizeSpecialBaseLocus (SpecialRationalMap) := (psi) -> psi#"specialBaseLocus";

embedding = method();

embedding (SpecialRationalMap) := (psi) -> psi#"embedding";

embedding' = method();

embedding' (SpecialRationalMap) := (psi) -> psi#"embedding2";

identityMap = method();

identityMap (Ring) := (R) -> rationalMap map(R,R);

check (SpecialRationalMap) := o -> (psi) -> (
   p := psi#"specialBaseLocus";
   assert isSubset(ideal source psi,lift(image p,ambient target p));
   psi' := psi#"inverse";
   point0 := point source psi;
   point0' := psi point0;
   assert(dim point0' == 1 and degree point0' == 1);
   assert((extend psi) (embedding psi) (point0) == point0');
   if psi' =!= null then (
       point1 := point source psi';
       point1' := psi' point1;
       assert(dim point1' == 1 and degree point1' == 1);
       assert((extend psi') (embedding psi') point1 == point1');
       assert(psi' point0' == point0 and psi point1' == point1);
   );
);

ideal (SpecialRationalMap) := (psi) -> (
    if (rationalMap psi)#"maps" === null then (rationalMap psi)#"maps" = {map rationalMap psi};
    ideal rationalMap psi
);

describe (SpecialRationalMap) := (phi) -> (
    Phi := rationalMap phi;
    S := trim lift(specialBaseLocus phi,ambient source phi);
    d := first max degrees ideal compress matrix Phi; 
    if dim S -1 != 2 or d =!= phi#"degreeForms" then error "internal error encountered";
    degs := flatten degrees S;
    descr:="rational map defined by forms of degree "|toString(d)|" having points of multiplicity "|toString(phi#"multiplicity")|newline|"along a surface of degree "|toString(degree S)|" and sectional genus "|toString((genera S)_1)|" cut out in PP^"|toString(numgens ring S -1)|if # unique degs == 1 then " by "|toString(#degs)|" hypersurfaces of degree "|toString(first degs) else " by "|toString(#degs)|" hypersurfaces of degrees "|toString(toSequence degs);
    descr=descr|newline|"source variety: "|toString(? ideal source Phi)|newline;
    descr=descr|"target variety: "|toString(? ideal target Phi)|newline;
    if Phi#"isDominant" =!= null then descr=descr|"dominance: "|toString(Phi#"isDominant")|newline;
    if Phi#"isBirational" =!= null then (
             descr=descr|"birationality: "|toString(Phi#"isBirational");
             if phi#"inverse" =!= null then descr=descr|" (the inverse map is known)";
             descr=descr|newline;
    );
    if Phi#"projectiveDegrees" =!= {} then descr=descr|"projective degrees: "|toString(Phi#"projectiveDegrees")|newline;
    descr=descr|"coefficient ring: "|toString(coefficientRing ambient target Phi#"map");
    net expression descr
);
