
newPackage(
       "TrisecantFlops",
    	Version => "1.4", 
        Date => "October 13, 2021",
    	Headline => "Some examples of Trisecant Flops",
        Authors => {{Name => "Giovanni Staglianò", Email => "giovannistagliano@gmail.com"}},
        PackageImports => {"PrimaryDecomposition"},
        PackageExports => {"SpecialFanoFourfolds"},
        AuxiliaryFiles => true,
        CacheExampleOutput => false,
        DebuggingMode => false,
        Reload => false
);

if version#"VERSION" < "1.18" then error "this package requires Macaulay2 version 1.18 or newer";

if SpecialFanoFourfolds.Options.Version < "2.4" then (
    <<endl<<"Your version of the SpecialFanoFourfolds package is outdated (required version 2.4 or newer);"<<endl;
    <<"you can manually download the latest version from"<<endl;
    <<"https://github.com/Macaulay2/M2/tree/development/M2/Macaulay2/packages."<<endl;
    <<"To automatically download the latest version of SpecialFanoFourfolds in your current directory,"<<endl;
    <<"you may run the following Macaulay2 code:"<<endl<<"***"<<endl<<endl;
    <<///run "curl -s -o SpecialFanoFourfolds.m2 https://raw.githubusercontent.com/Macaulay2/M2/development/M2/Macaulay2/packages/SpecialFanoFourfolds.m2";///<<endl<<endl<<"***"<<endl;
    error "required SpecialFanoFourfolds package version 2.4 or newer";
);

export{"trisecantFlop","specialRationalMap"};

dir = TrisecantFlops#"auxiliary files";

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
   projectiveVariety(D,MinimalGenerators=>false,Saturate=>false)
);

trisecantFlop = method(Options => {Verbose => false});
EXmap := local EXmap;
surface EmbeddedProjectiveVariety := X -> X#"SurfaceContainedInTheFourfold";
extend MultirationalMap := o -> Phi -> Phi.cache#"extension";
trisecantFlop ZZ := o -> i -> (
    if instance(EXmap_i,MultirationalMap) then return EXmap_i;
    N := {(0,5),(1,0),(2,3),(3,0),(4,1),(5,6),(6,0),(7,1),(8,0),(9,0),(10,0),(11,3),(12,3),(13,0),(14,4),(15,0),(16,3),(17,0)};
    E := {(0,-23),(1,11),(2,-14),(3,13),(4,-1),(5,-32),(6,27),(7,18),(8,46),(9,70),(10,14),(11,-14),(12,-14),(13,8),(14,-20),(15,29),(16,-2),(17,16)};
    f := example(i,Verbose=>o.Verbose);
    X := specialCubicFourfold(specialBaseLocus f,ideal source f,InputCheck=>0,NumNodes=>(last N_i));
    (surface X).cache#"euler" = last E_i;
    (surface X).cache#"rationalParametrization" = check multirationalMap({parametrizeSpecialBaseLocus f},surface X);
    Y := projectiveVariety(target f,MinimalGenerators=>false,Saturate=>false);
    T := projectiveVariety(nonMinimalAssociatedK3surface i,MinimalGenerators=>false,Saturate=>false);
    if i == 7 then Y = specialGushelMukaiFourfold(T,Y,InputCheck=>0);
    if i == 15 then Y = specialCubicFourfold(T,Y,InputCheck=>0,NumNodes=>(last N_15)); 
    if i != 7 and i != 15 then Y#"SurfaceContainedInTheFourfold" = T;
    F := multirationalMap f#"rationalMap";
    assert(ring target F === ring Y);
    F#"target" = Y;
    assert(ring source F === ring X);
    F#"source" = X;
    Fe := multirationalMap (extend f)#"rationalMap";
    assert(ring target Fe === ring Y);
    Fe#"target" = Y;
    F.cache#"extension" = Fe;
    if F#"inverse" =!= null or not(i == 10 or i == 14 or i == 16 or i == 17) then (
        assert(F#"inverse" =!= null);
        assert(ring target inverse F === ring X);
        (inverse F)#"target" = X;
        assert(ring source inverse F === ring Y);
        (inverse F)#"source" = Y;
        Ge := multirationalMap (extend inverse f)#"rationalMap";
        assert(ring target Ge === ring X);
        Ge#"target" = X;
        if i == 7 then (
            assert(ideal ring source Ge === ideal grassmannianHull Y);
            (surface Y).cache#"euler" = 24;
        );
        if i == 15 then (
            (surface Y).cache#"euler" = last E_15;
        );
        (inverse F).cache#"extension" = Ge;
        X.cache#"rationalParametrization" = inverse F;
        assert(f#"inverse" =!= null);
        (surface Y).cache#"rationalParametrization" = check multirationalMap({parametrizeSpecialBaseLocus inverse f},surface Y);
    );
    EXmap_i = F
);

trisecantFlop (Nothing,ZZ) := o -> (nu,i) -> (
    f := multirationalMap example(null,i,Verbose=>o.Verbose);
    assert(ideal ring source f === ideal ring source trisecantFlop(i,Verbose=>o.Verbose));
    f
);

trisecantFlop (ZZ,Nothing) := o -> (i,nu) -> (
    g := multirationalMap example(i,null,Verbose=>o.Verbose);
    assert(ideal ring source g === ideal ring target trisecantFlop(i,Verbose=>o.Verbose));
    g
);

load (dir|"doc.m2");

