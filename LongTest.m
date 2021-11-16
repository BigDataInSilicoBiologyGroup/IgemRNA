addpath('Scripts');

TestCase_deleteInactiveGenes();
TestCase_calculateFluxShifts();
TestCase_calculatePercentile();
TestCase_filterNonFluxReactions();
TestCase_calculateMinimumRequirements();
TestCase_createContextSpecificModel();
TestCase_filterRateLimittingReactions();
TestCase_findGenesAboveThresholdGT1();
TestCase_findGenesAboveThresholdLocal1();
TestCase_findGenesAboveThresholdLocal2();
TestCase_findGenesBelowThresholdGT1();
TestCase_findGenesBelowThresholdLocal1();
TestCase_findGenesBelowThresholdLocal2();
TestCase_findHighlyLowlyExpressedGenesGT1();
TestCase_findHighlyLowlyExpressedGenesLT1();
TestCase_findHighlyLowlyExpressedGenesLT2();
TestCase_findUpDownRegulatedGenes();

disp('DONE!');