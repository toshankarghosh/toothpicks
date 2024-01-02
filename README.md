  
# Code #
This simulated the motion of a  rod consisting of a point mass
and a massless stick placed on a vibrating base. 

Consider a CP stick of length $L$ that is connected to a stiffness torsion spring $k$ and damping $\gamma$ placed on the platform that is vibrating, $z_s= A \sin \omega t$. 
The stick consists of a mass less rod that has its base at C and the mass $m$ at P. The points $P:(x_p,z_p)$ and $C: (x_c, z_c)$ describe the top and the bottom ends of the stick.  Here, $x_c= x_p- L\sin \theta$  and $z_c= z_p- L\cos \theta $. 

Depending on the constraints, one of the following four phases of motion are in effect. The motion continues in a particular phase until one or more conditions are violate. These phases  are

1. Flight
2. Pivot
3. Sliding Left
4. Sliding Right

## Data Structure 

* setup
    * setup.p  : Stores the  physical parameters  of the rod (m, l, ..),  the vibratiing plate (A, omega,), torsional spring (k, gamma, )
    * setup.IC : Stores the initial Coditions for Bottom and top  of the Stick 
    * setup.Tspan   : stores the  initial and the final time 
* D
  * D.phase
  * D.code
  * D.data
      * D.data.phase 
      * D.data.time
      * D.data.state
        * D.data.state.xc
        * D.data.state.yc
        * D.data.state.th
        * D.data.state.dxc
        * D.data.state.dyc
        * D.data.state.dth
        * D.data.state.xp
        * D.data.state.yp
        * D.data.state.dxp
        * D.data.state.dyp
        * D.data.state.ys
        * D.data.state.dys
      * D.data.contact
        * D.data.contact.Fx 
        * D.data.contact.Fy
  *  D.Jumps,
  *  D.JumpIdx



 
% setup.Tspan   : stores the  initial and the final time 
## Dependency of  the files 
![image](https://github.com/toshankarghosh/toothpicks/assets/34761306/458c2d3d-808b-4464-9c26-5b885eb433af)
The  file <main_rod.m> is the main file.  


* <simulate_flight.m>
	* <dynamics_flight.m> : sets up the equations of motion for the flight phase for the ODE45 solver 
  	* <Event_Flight.m>	
	* <Table.m>	
	
   
	


* <simulate_hinge.m>
	* <dynamics_hinge.m> : sets up the equations of motion for the hinge phase for the ODE45 solver 
  	* <Event_Hinge.m>	
	* <Table.m>
	
	
	
	
* <simulate_slideNeg.m>
	* <dynamics_slideNeg.m>	:  sets up the equations of motion for the slide left phase for the ODE45 solver
  	* <Event_SlideNeg.m>
	* <Table.m>
	
	
	
* <simulate_slidePos.m>	
	* <dynamics_slidePos.m>	:  sets up the equations of motion for the slide right phase for the ODE45 solver
	* <Event_SlidePos.m>	
	* <Table.m>
	

