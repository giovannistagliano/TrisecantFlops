beginDocumentation() 
document { 
Key => TrisecantFlops, 
Headline => "Some examples of Trisecant Flops",
Contributors => {UL {{"Francesco Russo <",HREF{"mailto: frusso@dmi.unict.it","frusso@dmi.unict.it"},">"}}}},
document { 
Key => {example,(example,ZZ),(example,Nothing,ZZ),(example,ZZ,Nothing),[example,Verbose]}, 
Headline => "examples of Trisecant Flops", 
Usage => "example i", 
Inputs => {"i" => ZZ => {"an integer between 0 and 17"}},
Outputs => {RationalMap => {"the i-th example of birational map ",TEX///$X\dashrightarrow W$///," in accordance to the Table 1 in the paper ",HREF{"https://arxiv.org/abs/1909.01263","Trisecant Flops, their associated K3 surfaces and the rationality of some Fano fourfolds"},"."}}, 
PARA{"In the following, we consider the third example and we call some methods to analyze the data."},
EXAMPLE {"mu = example 3;","describe inverse mu","S = specialBaseLocus mu;",
         "? S","U = specialBaseLocus inverse mu;","U == nonMinimalAssociatedK3surface 3","? U","mu' = extend mu;",
         "fibre = mu'^*(point target mu');","? fibre","degree(S + fibre)"},
PARA{"Below we show the time needed to execute each example."},
EXAMPLE {"///for i from 1 to 17 do (<<i; time example i)///;"},
PARA{"The commands ",TT "example(,i)"," and ",TT "example(i,)"," produce, respectively, the birational maps ",TEX///$X\dashrightarrow Y$///," and ",TEX///$W\dashrightarrow Y$///," in the diagram (0.1) of the aforementioned paper."},
EXAMPLE {"describe example(,3)", "describe example(3,)"}
},
undocumented {nonMinimalAssociatedK3surface,(nonMinimalAssociatedK3surface,ZZ),
              specialRationalMap,
              (specialRationalMap,List),
              (specialRationalMap,Ideal,ZZ,ZZ),
              (specialRationalMap,RationalMap,Ideal,ZZ,ZZ),
              (specialRationalMap,RationalMap,RationalMap,ZZ,ZZ),
              (specialRationalMap,RationalMap,ZZ,ZZ)};
document { 
Key => {specialBaseLocus}, 
Headline => "special base locus of a rational map", 
Usage => "specialBaseLocus f", 
Inputs => {"f" => RationalMap => {"defined by a linear system of forms of degree ",TEX///$d$///," having points of multiplicity ",TEX///$e$///," along a subscheme ",TEX///$S$///}},
Outputs => {Ideal => {"the ideal of ",TEX///$S$///}}, 
EXAMPLE {"f = extend example 1;","S = specialBaseLocus f;","ideal matrix f == ideal matrix rationalMap(S,5,2)"},
SeeAlso => {"parametrizeSpecialBaseLocus"}
}
document { 
Key => {parametrizeSpecialBaseLocus}, 
Headline => "parameterization of the special base locus of a rational map", 
Usage => "parametrizeSpecialBaseLocus f", 
Inputs => {"f" => RationalMap => {"defined by a linear system of forms of degree ",TEX///$d$///," having points of multiplicity ",TEX///$e$///," along a (rational) subscheme ",TEX///$S$///}},
Outputs => {RationalMap => {"a parameterization of ",TEX///$S$///}}, 
EXAMPLE {"f = extend example 1;","j = parametrizeSpecialBaseLocus f;", "image j == specialBaseLocus f"},
SeeAlso => {"specialBaseLocus"}
}
document { 
Key => {randomQuinticDelPezzoSurfaceIntersectingTheSpecialBaseLocusOfExample7AlongADegree10EGenus6Curve}, 
Headline => "construct special quintic del Pezzo surfaces", 
Usage => "randomQuinticDelPezzoSurfaceIntersectingTheSpecialBaseLocusOfExample7AlongADegree10EGenus6Curve()", 
Inputs => {Nothing => {"nothing"}},
Outputs => {Ideal => {"the ideal of a random quintic del Pezzo surface intersecting the special base locus of ",TO example," 7 along a degree 10 e genus 6 curve"}},
EXAMPLE {"f = example 7;","S = specialBaseLocus f;", "D = randomQuinticDelPezzoSurfaceIntersectingTheSpecialBaseLocusOfExample7AlongADegree10EGenus6Curve();", "?D", "(codim(D+S), degree(D+S))", "Q = (extend f) D,; degree Q"},
}

