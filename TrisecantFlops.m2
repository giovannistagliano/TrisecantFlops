
newPackage(
    "TrisecantFlops",
    Version => "2.0",
    Date => "November 24, 2026",
    Headline => "Some examples of trisecant flops",
    Authors => {{Name => "Giovanni Staglianò", Email => "giovanni.stagliano@unict.it"}},
    PackageExports => {"SpecialFanoFourfolds"},
    DebuggingMode => false,
    Reload => false
);

if SpecialFanoFourfolds.Options.Version < "2.8.1" then error "the package SpecialFanoFourfolds is outdated (required version 2.8.1 or newer); see updatePackage";

importFrom_SpecialFanoFourfolds {"availableExamples","fanoMap","surfaceDeterminingInverseOfFanoMap"};

-- The i-th trisecant flop is obtained from example(toString i,1) of the local examples archive of SpecialFanoFourfolds:
-- it is the restriction to the cubic fourfold of its Fano map (stored in the archive).
-- i => (degree and sectional genus of the surface contained in the cubic fourfold, discriminant)
TrisecantFlopsInArchive = hashTable {
    0 => (9,2,42), 1 => (8,3,14), 2 => (7,0,26), 3 => (10,6,38), 4 => (7,1,26), 5 => (8,0,38),
    6 => (11,8,14), 7 => (10,6,14), 8 => (13,12,14), 9 => (14,15,14), 10 => (11,7,38), 11 => (8,1,38),
    12 => (8,1,38), 13 => (8,2,14), 14 => (8,0,26), 15 => (13,11,26), 16 => (11,6,26), 17 => (11,7,26)
};

trisecantFlopFourfold = (i,verb) -> (
    if i < 0 or i > 17 then error "expected integer between 0 and 17";
    str := toString i;
    (d,g,D) := TrisecantFlopsInArchive#i;
    hint := "; the reference examples archive can be downloaded from GitHub with store \"@\" (warning: this replaces the current local examples archive, which can first be saved with export localExamplesArchive())";
    pre := "trisecantFlop " | str | " requires example(\"" | str | "\",1) of the local examples archive";
    if not member((1,str),availableExamples()) then error(pre | ", which is not present" | hint);
    X := example(str,1,Verbose=>verb);
    S := surface X;
    if not (instance(X,CubicFourfold) and char coefficientRing X == 10000019 and degree S == d and sectionalGenus S == g and discriminant X == D)
    then error(pre | ", which does not have the expected invariants (cubic fourfold over ZZ/10000019 containing a surface of degree " | toString d | " and sectional genus " | toString g | ", discriminant " | toString D | ")" | hint);
    if not (S.cache#?("fanoMap",ambientFivefold X) and S.cache#?("surfaceDeterminingInverseOfFanoMap",ideal X))
    then error(pre | ", which does not contain the data of the Fano map" | hint);
    X
);

trisecantFlop ZZ := o -> i -> (
    X := trisecantFlopFourfold(i,o.Verbose);
    if X.cache#?"trisecantFlop" then return X.cache#"trisecantFlop";
    if o.Verbose then << "-- restricting the Fano map to the fourfold" << endl;
    Mu := rationalMap fanoMap X;
    mu := Mu|X;
    U := surfaceDeterminingInverseOfFanoMap X;
    W := if i == 15 then specialFourfold(U,target mu,InputCheck=>0,NumNodes=>0) else specialFourfold(U,target mu,InputCheck=>0);
    if i == 7 then (surface W).cache#"euler" = 24;
    if i == 15 then (surface W).cache#"euler" = 29;
    mu#"target" = W;
    mu#"isDominant" = true;
    mu#"isBirational" = true;
    mu.cache#"extension" = Mu;
    X.cache#"trisecantFlop" = mu
);

extend RationalMap := o -> Phi -> (
    if not Phi.cache#?"extension" then error "extension of the rational map not available";
    Phi.cache#"extension"
);

beginDocumentation()

document {Key => TrisecantFlops,
Headline => "Some examples of trisecant flops",
Contributors => {UL {{"Francesco Russo <",HREF{"mailto: frusso@dmi.unict.it","frusso@dmi.unict.it"},">"}}},
PARA {"This package provides the examples of trisecant flops from Table 1 of the paper ",HREF{"https://arxiv.org/abs/1909.01263","Trisecant Flops, their associated K3 surfaces and the rationality of some Fano fourfolds"},", by F. Russo and G. Staglianò. See the function ",TO2{(trisecantFlop,ZZ),"trisecantFlop"},"."},
PARA {"Since version 2.0, the package does not contain any data: the examples are taken from the local examples archive of ",TO "SpecialFanoFourfolds::SpecialFanoFourfolds",", which can be obtained with ",TT "store \"@\"","."}}

document {Key => {(trisecantFlop,ZZ),[trisecantFlop,Verbose]},
Headline => "examples of trisecant flops",
Usage => "trisecantFlop i",
Inputs => {"i" => ZZ => {"an integer between 0 and 17"}},
Outputs => {RationalMap => {"the i-th example of birational map ",TEX///$X\dashrightarrow W$///," in accordance to the Table 1 in the paper ",HREF{"https://arxiv.org/abs/1909.01263","Trisecant Flops, their associated K3 surfaces and the rationality of some Fano fourfolds"},"."}},
PARA {"The cubic fourfold ",TEX///$X$///," is ",TT "example(\"i\",1)"," of the local examples archive of ",TO "SpecialFanoFourfolds::SpecialFanoFourfolds",", and the map is the restriction to ",TEX///$X$///," of its Fano map, which is returned by ",TT "extend mu",". If the example is not present in the local archive, or does not have the expected invariants, an error is raised; the reference archive can be downloaded with ",TT "store \"@\""," (note that this replaces the current local archive, which can first be saved with ",TT "export localExamplesArchive()",")."},
PARA {"In the following, we consider the 7th example."},
PRE ///mu = trisecantFlop 7;
X = source mu;
describe X
W = target mu;
describe W
S = surface X;
T = surface W;
mu' = extend mu; -- the Fano map, defined on the ambient space of X
F = mu'^* point W;
(describe F, describe (F*S))///,
PARA {"Some examples, in particular the 16th one, take a long time to load."},
SeeAlso => {"SpecialFanoFourfolds::example(String)", "SpecialFanoFourfolds::localExamplesArchive"}}

undocumented {(extend,RationalMap)}
