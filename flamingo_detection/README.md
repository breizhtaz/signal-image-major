Author
------
Gweltaz Lever, ISAE Supaero
All rights reserved.

Description
-----------
The project aims at automatically detecting and counting flamingos in an aerial image. Circles are matched with flamingos by maximizing an energy function (i.e. minimizing the associated probability).

In short, the Gibbs density associated with the marked point process of circles is defined according to a Poisson measure. The issue is thus reduced to an energy minimization, entailing a regularization term - an a priori knowledge - and a data term linking flamingos to local features in the image. The more color you find, the higher the chance that the circle is placed on a flamingo.

Techniques involved: MRFs, the Birth and Death algorithm (X. Descombes), Point processes, Poisson distribution.

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
