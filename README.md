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
    - Rotation is passive or alias. This is more common in aerospace applications. Vs the active or alibi rotation that's more common in robotics. For example, in the /functions/rot_x.m, notice the the signs for the sine functions are flipped compare to those from the robotics world or Wiki.
  - Quaternion
    - Scalar-Last.
    - Quaternion multiplication from right-to-left just like DCM. This is just the notation, the ideal is to be consistent with DCM and minimize potential implementation and usage error. Under the hood, at elemental multiplication level, it is still comform to right-handedness. 
    

Future todo
- Satellite dynamics, ie $J\dot{\omega}=\tau-[\omega\times]J\omega$
- Sensor Models
- Actuator Models
- Attitude estimator (EKF)
- Magnetic field model (IGRF or WMM)
- Feedback PID controller design with Laplace domain, root locus, Bode plot etc.

Let me know if something you'd like me to add!
