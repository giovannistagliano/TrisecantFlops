beginDocumentation() 

document {Key => TrisecantFlops, 
Headline => "Some examples of trisecant flops",
Contributors => {UL {{"Francesco Russo <",HREF{"mailto: frusso@dmi.unict.it","frusso@dmi.unict.it"},">"}}},
PARA {"See the function ",TO2{(trisecantFlop,ZZ),"trisecantFlop"},"."}}

document {Key => {"Examples of trisecant flops using the old version of the package"},
Usage => "example i", 
Inputs => {"i" => ZZ => {"an integer between 0 and 17"}},
Outputs => {{"the i-th example of birational map ",TEX///$X\dashrightarrow W$///," in accordance to the Table 1 in the paper ",HREF{"https://arxiv.org/abs/1909.01263","Trisecant Flops, their associated K3 surfaces and the rationality of some Fano fourfolds"},"."}}, 
PARA{"In the following, we consider the 7th example and we call some functions to analyze the data."},
EXAMPLE {"debug TrisecantFlops;", "mu = example 7;","describe inverse mu","S = specialBaseLocus mu;",
         "? S", "parametrizeSpecialBaseLocus mu;", "U = specialBaseLocus inverse mu;",
         "assert(lift(U,ambient ring U) == nonMinimalAssociatedK3surface 7)","? U","mu' = extend mu;",
         "fibre = mu'^*(point target mu');","? fibre","degree(S + fibre)"},
PARA{"The commands ",TT "example(,i)"," and ",TT "example(i,)"," produce, respectively, the birational maps ",TEX///$X\dashrightarrow Y$///," and ",TEX///$W\dashrightarrow Y$///," in the diagram (0.1) of the aforementioned paper."},
EXAMPLE {"describe example(,7)", "describe example(7,)"},
PARA{"Below we show the time needed to execute all the examples."},
EXAMPLE {"///for i to 17 do (<<i; time example i)
0     -- used 9.95438 seconds
1     -- used 1.09944 seconds
2     -- used 0.933729 seconds
3     -- used 1.12644 seconds
4     -- used 0.8203 seconds
5     -- used 11.4551 seconds
6     -- used 3.38757 seconds
7     -- used 3.57946 seconds
8     -- used 162.847 seconds
9     -- used 555.309 seconds
10     -- used 59.2267 seconds
11     -- used 6.00626 seconds
12     -- used 13.175 seconds
13     -- used 3.67424 seconds
14     -- used 24.7608 seconds
15     -- used 111.319 seconds
16     -- used 625.068 seconds
17     -- used 31.1299 seconds
///;"},
SeeAlso => {(trisecantFlop,ZZ)}}

document {Key => {(trisecantFlop,ZZ),(trisecantFlop,ZZ,Nothing),(trisecantFlop,Nothing,ZZ),[trisecantFlop,Verbose]}, 
Headline => "examples of Trisecant Flops", 
Usage => "trisecantFlop i", 
Inputs => {"i" => ZZ => {"an integer between 0 and 17"}},
Outputs => {{"the i-th example of birational map ",TEX///$X\dashrightarrow W$///," in accordance to the Table 1 in the paper ",HREF{"https://arxiv.org/abs/1909.01263","Trisecant Flops, their associated K3 surfaces and the rationality of some Fano fourfolds"},"."}}, 
PARA{"In the following, we consider the 7th example and we call some functions to analyze the data."},
EXAMPLE {"mu = trisecantFlop 7;","X = source mu;","describe X","W = target mu;","describe W",
         "S = surface X;","T = surface W;","mu;","eta = inverse mu;",
         "mu' = extend mu;","F = mu'^* point W;","(describe F,describe (F*S))",
         "eta' = extend eta;","G = eta'^* point X;","(describe G,describe (G*T))"},
SeeAlso => {"Examples of trisecant flops using the old version of the package"}}

undocumented {specialRationalMap,
             (specialRationalMap,List),
             (specialRationalMap,Ideal,ZZ,ZZ),
             (specialRationalMap,RationalMap,Ideal,ZZ,ZZ),
             (specialRationalMap,RationalMap,RationalMap,ZZ,ZZ),
             (specialRationalMap,RationalMap,ZZ,ZZ)}
             
undocumented {exampleOfRationalIntersectionsOfThreeQuadricsInP7}

