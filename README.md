![ATTITUDE](img/ive_got_attitude.png)

# I've got Attitude!
A collection of attitude functions for aerospace application.
- /functions
  - Small collections of attitude functions from Crassidis' books and classes.
  - 7 core "Lego-blocks" functions have the prefix of "fun_"
  - The benefit is that
- Attitude conventions
  - All right-handed, ONLY! 
    - That means for DCM, the determinant is +1
    - That means for attitude quaternion, $i^2=j^2=k^2=ijk=-1$
    - Beware there some places like NASA JPL and Draper may use left-handed attitude parameters unannounced. Especially for attitude quaternion and functions, always verify the handedness. Here are a verification example
      - /img/quaternion_handedness_verification_1.jpg
      - /img/quaternion_handedness_verification_2.jpg
  - Quaternion
    - Scalar-Last
