Author
------
Gweltaz Lever, ISAE Supaero
All rights reserved.

Description
-----------
The project aims at detecting and counting flamingos in an aerial image.

The techniques involved are MRFs, the Birth and Death algorithm (X. Descombes), Point processes

Usage
-----
The scripts can be launched within matlab. Just make sure the image used in the scripts is located in the right folder.

Algorithms
----------
The following approaches have been chosen:
- Step 1: detection_sans_a_priori.m
	Algorithm searches for the best placement of all the circles without any assumptions (a priori knowledge)
	The number of circles is fixed.
	
- Step 2: detection_avec_a_priori.m
	The algorithm performs the same steps as the previous one. However, an a priori knowledge is added: circles/flamingos are not superimposed in the image. Concretely, this means that we add the a priori term to the energy function.
	
- Step 3: detection_pp.m
	 This final algorithm makes no assumptions about the number of flamingos in the image. Through a Birth and death algorithm and a point process (custom seed algorithm with temperature decrease), the circles are successively added and removed from the image until the maximization of the function is reached.

For french speakers, more information is available in the PDF. 
