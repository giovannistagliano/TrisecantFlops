-- These are the commands to install and view the documentation:
--   installPackage "TrisecantFlops";
--   viewHelp TrisecantFlops
----------------------------------------------------------------

if version#"VERSION" < "1.17" then error "this package requires Macaulay2 version 1.17 or newer";

newPackage(
       "TrisecantFlops",
    	Version => "1.2.1", 
        Date => "January 31, 2021",
    	Headline => "Some examples of Trisecant Flops",
        Authors => {{Name => "Giovanni Staglianò", Email => "giovannistagliano@gmail.com"}},
        PackageImports => {"PrimaryDecomposition","SpecialFanoFourfolds"},
        PackageExports => {"SpecialFanoFourfolds"},
        AuxiliaryFiles => true,
        CacheExampleOutput => true,
        DebuggingMode => false,
        Reload => false
);

export{"example", "specialBaseLocus", "parametrizeSpecialBaseLocus", "nonMinimalAssociatedK3surface", "specialRationalMap", "randomQuinticDelPezzoSurfaceIntersectingTheSpecialBaseLocusOfExample7AlongADegree10EGenus6Curve"};

dir := searchPath "TrisecantFlops/SRM.m2";
if #dir == 0 then error "can't locate directory TrisecantFLops";
dir = (first dir)|"TrisecantFlops/";
-- <<"dir: "<<dir<<endl;

load (dir|"SRM.m2");

eX := local eX;

example = method(Options => {Verbose => false});
example (ZZ) := o -> (jj) -> (
    if jj < 0 or jj > 17 then error "expected integer between 0 and 17";
    if class eX_jj =!= SpecialRationalMap then (
        nfile := dir|toString(jj)|".dat";
        if o.Verbose then <<"-- loading data file "<<nfile<<"   ";
        F := get nfile;
        if o.Verbose then <<"done!"<<endl<<"-- valuing data file... ";
        F = value F;
        if o.Verbose then <<"done!"<<endl<<"-- executing data file...";
        eX_jj = F();
        if o.Verbose then <<"done!"<<endl;
    ); 
    return eX_jj;
);

nonMinimalAssociatedK3surface = method();
nonMinimalAssociatedK3surface (ZZ) := (jj) -> (
    f := example jj;
    if jj == 10 or jj == 14 or jj == 16 or jj == 17 then return (value get(dir|toString(jj)|"ass.dat"))(gens ambient target f) else return trim lift(specialBaseLocus inverse f,ambient target f);
);

eY := local eY;

example (Nothing,ZZ) := o -> (nu,jj) -> (
    if jj < 0 or jj > 17 then error "expected integer between 0 and 17";
    if jj == 15 then error "not implemented yet";
    if class eY_jj =!= RationalMap then (
        nfile := dir|"fromXtoY"|toString(jj)|".dat";
        if o.Verbose then <<"-- loading data file "<<nfile<<"   ";
        F := get nfile;
        if o.Verbose then <<"done!"<<endl<<"-- valuing data file... ";
        F = value F;
        if o.Verbose then <<"done!"<<endl<<"-- executing data file...";
        eY_jj = F();
        if o.Verbose then <<"done!"<<endl;
    ); 
    return eY_jj;
);

eW := local eW;

example (ZZ,Nothing) := o -> (jj,nu) -> (
    if jj < 0 or jj > 17 then error "expected integer between 0 and 17";
    if jj == 15 then error "not implemented yet";
    if class eW_jj =!= RationalMap then (
        nfile := dir|"fromWtoY"|toString(jj)|".dat";
        if o.Verbose then <<"-- loading data file "<<nfile<<"   ";
        F := get nfile;
        if o.Verbose then <<"done!"<<endl<<"-- valuing data file... ";
        F = value F;
        if o.Verbose then <<"done!"<<endl<<"-- executing data file...";
        eW_jj = F();
        if o.Verbose then <<"done!"<<endl;
    ); 
    return eW_jj;
);

randomQuinticDelPezzoSurfaceIntersectingTheSpecialBaseLocusOfExample7AlongADegree10EGenus6Curve = () -> (
   S := specialBaseLocus example 7;
   x := gens ring S;
   q := ideal(x_4+1011695*x_5,x_3+2243139*x_5,x_2-480752*x_5,x_1+771527*x_5,x_0); -- singular point of S
   h := (rationalMap q)|S;
   ideal h;
   M := random(1,ring S) * matrix (h#"maps")_0 + random(0,ring S) * matrix (h#"maps")_1;
   assert(h == rationalMap(source h,target h,M));
   J := top ideal lift(M,ring S);
   D := first select(unique apply(entries transpose mingens kernel matrix select(entries transpose syz gens J,g -> max flatten degrees ideal g == 1),g' -> trim ideal g'),i -> dim i >= 1);
   assert(? D == "smooth surface of degree 5 and sectional genus 1 in PP^5 cut out by 5 hypersurfaces of degree 2" and dim(D + S) == 2 and degree(D + S) == 10);
   D
);

load (dir|"doc.m2");

