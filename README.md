  
# Code #
This simulated the motion of a  rod consisting of a point mass
and a massless stick placed on a vibrating base. 

Consider a CP stick of length $L$ that is connected to a stiffness torsion spring $k$ and damping $\gamma$ placed on the platform that is vibrating, $z_s= A \sin \omega t$. 
The stick consists of a mass less rod that has its base at C and the mass $m$ at P. The points $P:(x_p,z_p)$ and $C: (x_c, z_c)$ describe the top and the bottom ends of the stick.  Here, $x_c= x_p- L\sin \theta$  and $z_c= z_p- L\cos \theta $.

## Data Structure 

*setup
    * setup.p  : Stores the  physical parameters  of the rod (m, l, ..),  the vibratiing plate (A, omega,), torsional spring (k, gamma, )
    * setup.IC : Stores the initial Coditions for Bottom and top  of the Stick 
    * setup.Tspan   : stores the  initial and the final time 
        * Sub-nested bullet etc
* Bullet list item 2



 
% setup.Tspan   : stores the  initial and the final time 
## Dependency of  the files 
![image](https://github.com/toshankarghosh/toothpicks/assets/34761306/458c2d3d-808b-4464-9c26-5b885eb433af)
The  file <main_rod.m> is the main file.  

# main_rod
