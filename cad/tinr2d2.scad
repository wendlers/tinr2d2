/**
 * TinCan robot 
 * 
 * 2014-01-05
 * Stefan Wendler
 * sw@kaltpost.de
 */

// ===============================================
// basic params
// ===============================================

can_hig=129;					// hight of tin can
							// 129 is for lavazza espresso can
can_tkn=2;					// thickness of tin can
can_rad=51;					// radius of tin can
							// 51 is for lavazza espresso can

base_hig=10;					// hight of top/bottom base
base_tkn=2;					// thickness of top/bottom base borders
base_rad=can_rad+base_tkn;	// radius of top/bottom base

leg_hig=can_hig;				// hight of main legs
leg_tkn=15;					// thickness of main legs
leg_wid=30;					// width of main legs

bod_rot=20;					// deg. of how much can is rotated in respect to the legs


// ===============================================
// what to show
// ===============================================

/* some views showing the robot as a whole */

// show_full_robot(0);
show_full_robot(1);
// show_exploded_robot();

/* the print views for exporting to STL/3D printer */

// print_front_wheel_ball();
// print_front_wheel_leg1();
// print_front_wheel_leg2();

// print_bottom_base();
// print_top_base();
// print_dome_top();

// print_leg1();
// print_leg2();

/* some test views of single parts */

// dome(base_rad, 3);
// dome_top(base_rad, 2);

// top_base();
// bottom_base();

// leg(leg_hig, leg_wid, leg_tkn, base_rad, 0);
// leg_drill_hole(leg_hig, leg_wid, leg_tkn, base_rad);

// front_wheel();

// front_wheel_leg(0);

/*
		translate([-can_rad-can_rad*0.5, 0, -40])
			rotate([0, 0, 90])
			{
				front_wheel_ball();
				translate([20, 0, 0])
					front_wheel_leg(0);
				translate([-20, 0, 0])
					mirror([1, 0, 0])
						front_wheel_leg(1);
			}
*/

// translate([-5, 0, 0]) cube([5, 5, 5], center=true);
// translate([ 5, 0, 0]) scale([1.05, 1.05, 1.05]) cube([5, 5, 5], center=true);

/*
	rotate([0, bod_rot, 0])
	{

		translate([-45, 0, 0])
		{
			translate([45, 0, 0])
				bottom_base();

			translate([0, 0, can_hig + 2 * base_tkn]) 
				top_base();
			translate([0, 0, can_hig+base_tkn]) 
			{
				dome_top(base_rad, 2);
			}

				can(can_hig, can_rad, can_tkn);
		}
*/
/*
		translate([-can_rad-can_rad*0.5, 0, -20])
			rotate([0, 0, 90])
				front_wheel();
		}
	}
*/

//	leg(leg_hig, leg_wid, leg_tkn, base_rad, 0);

//	mirror([0, 1, 0]) leg(leg_hig, leg_wid, leg_tkn, base_rad, 0);

// mirror([0, 1, 0])
// mirror([0, 1, 0])
//	translate([-leg_wid/2, base_rad, 0])
//			translate([(leg_wid-23)/2, 24, 15])
//				mirror([0, 1, 0]) wheel();

// ===============================================
// modules
// ===============================================

module can(hig, rad, tkn)
{
	translate([0, 0, tkn]) {
		difference() {
			cylinder(h=hig, r=rad);
			translate([0, 0, tkn]) {
				cylinder(h=hig-tkn, r=rad-tkn);
			}
		}
	}
}

module bottop_cylseg(rad, tkn)
{
	bor=10;		// border to edge of base

	intersection() {	
		translate([bor / 2, bor / 2, 0]) {
			cube([rad-bor, rad-bor, tkn]);
		}
		cylinder(h=tkn, r=rad-bor);
	}
}

module bottop(hig, rad, tkn, halfseg) 
{
	difference() {
		cylinder(h=hig, r=rad);

		if(halfseg != 0)
		{
			translate([0, 0, tkn])
				cylinder(h=hig-tkn, r=rad-tkn);

			bottop_cylseg(rad, tkn);
		}
		else
		{
			cylinder(h=hig, r=rad-tkn);
		}

		if(halfseg != 1 && halfseg != 0)
		{
			rotate([0, 0, 90])
				bottop_cylseg(rad, tkn*2);

			rotate([0, 0, 180])
				bottop_cylseg(rad, tkn*2);
		}	

		if(halfseg != 0)
		{
			rotate([0, 0, 270])
				bottop_cylseg(rad, tkn*2);
		}
	}
}

module wheel()
{
	translate([11.5, -2, 11])
		union() {
			difference() {
				rotate([90, 0, 0])
					cylinder(h=7.6, r=69/2);

				rotate([90, 0, 0])
					cylinder(h=7.6, r=69/2-5);
			}
			difference()
			{

				rotate([90, 0, 0])
					cylinder(h=7.6, r=69/2-20);	

				rotate([90, 0, 0])
					cylinder(h=8, r=2.2);

			}

			difference() {
			for ( i = [0 : 5] )
			{
				rotate([0, 60 * i, 0, 0])
					translate([0, -3, 0])
						cylinder(h=69/2 - 3, r=2);
			}
			rotate([90, 0, 0])
				cylinder(h=8, r=2.2);
			}
		}
}

module motor(show_wheel)
{
	union() {
		cube([23, 21, 37]);
		intersection() {
			translate([11.5, 11.5, 37])
				cylinder(h=30, r=11.5);
	
			translate([0, 3, 37])
				cube([23, 18, 30]);
		}
		translate([11.5-6, 21, 37])
			cube([12, 3, 30]);

		translate([11.5, 0, 11])
			rotate([90, 0, 0])
				cylinder(h=8, r=2);
	}

	if(show_wheel == 1)
	{
		wheel();
	}
	else if(show_wheel == 2)
	{
		translate([0, -45, 0])
			wheel();
	}
}

module bottom(hig, rad, tkn)
{
	union() {
		bottop(hig, rad, tkn, 1);

		difference() {
			translate([rad/3, -rad - 18, 0])	
				cube([rad-rad/3, rad/2, hig+5]);
				// cube([rad-rad/3, 2*rad + 36, hig+5]);
			cylinder(h=hig+5, r=rad - tkn);
		}

		mirror([0,1,0])
			difference() {
				translate([rad/3, -rad - 18, 0])	
					cube([rad-rad/3, rad/2, hig+5]);
					// cube([rad-rad/3, 2*rad + 36, hig+5]);
				cylinder(h=hig+5, r=rad - tkn);
			}

		difference() {	
			translate([rad/3, +rad, 0])
				cylinder(h=hig+5, r=18);
			cylinder(h=hig+5, r=rad - tkn);
		}

		difference() {
			mirror([0, 1, 0])
				translate([rad/3, +rad, 0])
					cylinder(h=hig+5, r=18);
			cylinder(h=hig+5, r=rad - tkn);
		}

		difference() {
			translate([+rad, +rad + 18, (hig+5)/2])
				rotate([90, 0, 0])
					cylinder(h=rad/2, r=(hig+5)/2);
					// cylinder(h=rad*2+36, r=(hig+5)/2);
			cylinder(h=hig + 5, r=rad - tkn);
		}

		mirror([0,1,0])
		difference() {
			translate([+rad, +rad + 18, (hig+5)/2])
				rotate([90, 0, 0])
					cylinder(h=rad/2, r=(hig+5)/2);
					// cylinder(h=rad*2+36, r=(hig+5)/2);
			cylinder(h=hig + 5, r=rad - tkn);
		}

	}
}

module top(hig, rad, tkn, leg_tkn)
{
	shl=base_rad/1.5; 

		union() {
			mirror([0, 0, 1]) bottop(hig, rad, tkn, 0);
	
			difference() {

				translate([-shl/2, rad-base_rad/4, -hig]) 
					cube([shl, base_rad/4, base_hig]);
		
				translate([0, 0, -hig])
					cylinder(h=hig, r=rad-tkn);
			}

			difference() {
				mirror([0, 1, 0])
					translate([-shl/2, rad-base_rad/4, -hig]) 
						cube([shl, base_rad/4, base_hig]);
			
				translate([0, 0, -hig])
					cylinder(h=hig, r=rad-tkn);
			}

			dome(rad , tkn);
		}
}

module leg_drill_hole(hig, wid, tkn, rad)
{
	translate([-wid/2, rad, 0]) {
			translate([wid/2, 25, hig+6]) 
				rotate([90, 0, 0]) 
					cylinder(h=30, r=3.0);	
	}
}

module leg(hig, wid, tkn, rad, show_mot)
{
	translate([-wid/2, rad, 0]) {
		
		difference() {
			union() {
				translate([wid/2, tkn, hig])
					rotate([90, 0, 0])
						cylinder(h=tkn, r=wid/2);
			
				cube([wid, tkn, hig - 40]);
				
				difference() {
					translate([tkn/2, tkn/2, hig-40])
						cylinder(h=40, r=tkn/2);
					translate([wid/4, 0, hig-40])
						cube([wid/2, tkn, 40]);

				}

				difference() {
					translate([+wid-tkn/2, tkn/2, hig-40])
						cylinder(h=40, r=tkn/2);

					translate([wid/4, 0, hig-40])
						cube([wid/2, tkn, 40]);
				}				
			}

			translate([wid/2, tkn+7.5, hig+5]) 
				rotate([90, 0, 0]) 
					cylinder(h=tkn, r=8);		

			translate([wid/2-1.5, tkn+2, hig+6]) 
				rotate([90, 0, 0]) 
					cylinder(h=2*tkn, r=3.2);		

			translate([wid/2+1.5, tkn+2, hig+6]) 
				rotate([90, 0, 0]) 
					cylinder(h=2*tkn, r=3.2);		

			translate([+wid/2-2, 0, hig+3]) 
				cube([4, 10, 6]);

			translate([(wid-23)/2, 24, 15])
				mirror([0, 1, 0]) motor(0);

			rotate([0, bod_rot, 0])
				translate([-wid/3, 0, -3])
					cube([2*wid, 2*tkn, 15]);

			rotate([0, -bod_rot*2, 0])
				translate([-wid/3, 0, -30])
					cube([2*wid, 2*tkn, 15]);

		}

		if(show_mot == 1)
		{
			translate([(wid-23)/2, 24, 15])
				mirror([0, 1, 0]) motor(1);
		}
		else if(show_mot == 2)
		{
			translate([(wid-23)/2, 24 + 45, 15])
				mirror([0, 1, 0]) motor(2);
		}
	}
}


module top_base()
{
	translate([0, 0, -can_hig - 2 * base_tkn])  
		translate([+45, 0, 0])
			rotate([0, -bod_rot, 0]) 
				difference()
				{
					rotate([0, bod_rot, 0])
					{
						translate([-45, 0, 0])
						{
							translate([0, 0, can_hig + 2 * base_tkn]) 
								top(base_hig, base_rad, base_tkn, leg_tkn);
						}
					}

					leg_drill_hole(leg_hig, leg_wid, leg_tkn, base_rad);
					mirror([0, 1, 0]) leg_drill_hole(leg_hig, leg_wid, leg_tkn, base_rad);
				}
}

module bottom_base()
{
	difference()
	{
		rotate([0, -bod_rot, 0])
		{
			difference()
			{
				rotate([0, bod_rot, 0])
					translate([-45, 0, 0])
						bottom(base_hig, base_rad, base_tkn);
 
				leg(leg_hig, leg_wid, leg_tkn, base_rad, 1);
				mirror([0, 1, 0]) 
						leg(leg_hig, leg_wid, leg_tkn, base_rad, 1);

				translate([8, -5, 19])
					cylinder(h=4, r=1.5, center=true);
				translate([8, +5, 19])
					cylinder(h=4, r=1.5, center=true);
			}
		}

		translate([-can_rad-can_rad*0.5, 0, -20])
			rotate([0, 0, 90])
				front_wheel_drill_holes();

	}
}

module front_wheel_ball()
{
	difference(){
		intersection()
		{
			cube([20, 30, 30], center=true);
			sphere(r=15);
		}
		rotate([90,0,90])
			cylinder(h=25,r=5,center=true);

		translate([10, 0, 0])
			rotate([90,0,90])
				cylinder(h=4.5,r=7,center=true);

		mirror([1, 0, 0])
			translate([10, 0, 0])
				rotate([90,0,90])
					cylinder(h=4.5,r=7,center=true);

	}
}

module front_wheel_leg(hole)
{
	tkn = 4;

	difference()
	{
		union() {

			translate([tkn, 0, 0])
			{

				translate([0.4, 0, 0])
					rotate([90,0,90])
						cylinder(h=8.7,r=4.5,center=true);

				translate([6.5, 0, 0])
					rotate([90,0,90])
							cylinder(h=4.3,r=6.5,center=true);

			}

			translate([10+3, 0, 10])
				cube([tkn, 20, 20], center=true);

			difference()
			{
				translate([0, -10, 18])
					cube([15, 20, tkn]);
				translate([8, -5, 19])
					cylinder(h=6, r=1.5, center=true);
				translate([8, +5, 19])
					cylinder(h=6, r=1.5, center=true);
			}

			translate([10+3, 0, 0])
				rotate([90,0,90])
					cylinder(h=4,r=10,center=true);
		}
		
		translate([10, 0, 0])
			rotate([90,0,90])
				cylinder(h=30,r=1.6,center=true);

		translate([15, 0, 0])
			rotate([90,0,90])
				cylinder(h=5,r=4,center=true);

		translate([10+4, 0, 16 - tkn])
			cube([tkn+10, 10, 11], center=true);
	}

}

module front_wheel_drill_holes()
{
	
	translate([8, -5, 19])
		cylinder(h=10, r=1.9, center=true);
	translate([8, +5, 19])
		cylinder(h=10, r=1.9, center=true);

	mirror([1, 0, 0])
	{
		translate([8, -5, 19])
			cylinder(h=10, r=1.9, center=true);
		translate([8, +5, 19])
			cylinder(h=10, r=1.9, center=true);
	}
}

module front_wheel()
{
	front_wheel_ball();
	front_wheel_leg(0);
	mirror([1, 0, 0])
		front_wheel_leg(1);
}

module dome2(rad, tkn)
{
	union()
	{

		difference()
		{
			difference()
			{
				sphere(r=rad);
				translate([0, 0, -rad/2])
					cube([2* rad, 2 * rad, rad], center=true);
			}
	
			difference()
			{
				sphere(r=rad-tkn);
				translate([0, 0, -rad/2])
					cube([2* rad, 2 * rad, rad], center=true);

			}
		}
	}
}

module dome_top(rad, tkn) 
{
	drad = rad*0.75;

	union()
	{
		translate([0, 0, rad*0.6])
			cylinder(h=tkn, r=drad);

		translate([0, 0, rad*0.6-tkn]) 
		{
			difference() 
			{
				cylinder(h=tkn*2, r=drad-tkn);
				cylinder(h=tkn*2, r=drad-2*tkn);
			}
		}
	}
}

module dome(rad, tkn)
{
	t=22;

	union()
	{
		difference()
		{
			cylinder(h=rad*0.6, r1=rad, r2=rad*0.75);
			cylinder(h=rad*0.6, r1=rad-tkn, r2=rad*0.75-tkn);
			translate([-rad+t/2, 0, rad/3.5])
				rotate([0, -bod_rot, 0])
						cube([t, 25, 25], center=true);
		}


		intersection() {

		difference()
		{
			cylinder(h=rad*0.6, r=rad*1.5);
			cylinder(h=rad*0.6, r1=rad-tkn, r2=rad*0.75-tkn);	
		}

		translate([-rad+t/2, 0, rad/3.5])
			rotate([0, -bod_rot, 0])
				difference() {
					cube([t, 25, 25], center=true);
					translate([tkn, 0, 0])
						cube([t, 25-tkn, 25-tkn], center=true);
					rotate([0, 90, 0])
						translate([-2.5, 0, -20])
							cylinder(h=20, r=5.5);
				}
		}
	}
}

module print_dome_top()
{
	translate([0, 0, base_rad*0.6+2])
		rotate([0, 180, 0])	
			dome_top(base_rad, 2);
}

module print_front_wheel_leg1()
{
	translate([0, 0, 15])
		rotate([0, 90, 0])	
			front_wheel_leg(0);
}

module print_front_wheel_leg2()
{
	translate([0, 0, 15])
		rotate([0, -90, 0])	
			mirror([1, 0, 0])
				front_wheel_leg(1);
}

module print_front_wheel_ball()
{
	translate([0, 0, 10])
		rotate([0, 90, 0])
			front_wheel_ball();
}

module print_bottom_base()
{
	bottom_base();
}

module print_top_base()
{
	translate([0, 0, base_hig])
		top_base();
}

module print_leg1()
{
	translate([0, 0, -can_rad-base_tkn])
		rotate([90, 0, 0])
			leg(leg_hig, leg_wid, leg_tkn, base_rad, 0);
}

module print_leg2()
{
	translate([0, 0, -can_rad-base_tkn])
		rotate([-90, 0, 0])
			mirror([0, 1, 0]) leg(leg_hig, leg_wid, leg_tkn, base_rad, 0);
}

module show_full_robot(showcan)
{
	rotate([0, bod_rot, 0])
	{
		translate([-45, 0, 0])
		{
			translate([45, 0, 0])
				bottom_base();
			translate([0, 0, can_hig + 2 * base_tkn]) 
				top_base();
			translate([0, 0, can_hig+base_tkn]) 
			{
				dome_top(base_rad, 2);
			}
			if(showcan == 1)
				can(can_hig, can_rad, can_tkn);
		}
		translate([-can_rad-can_rad*0.5, 0, -20])
			rotate([0, 0, 90])
				front_wheel();
	}

	leg(leg_hig, leg_wid, leg_tkn, base_rad, 1);
	mirror([0, 1, 0]) leg(leg_hig, leg_wid, leg_tkn, base_rad, 1);
}

module show_exploded_robot()
{
	rotate([0, bod_rot, 0])
	{
		translate([-45, 0, 0])
		{
			translate([45, 0, 0])
				bottom_base();
			translate([0, 0, can_hig + 2 * base_tkn]) 
				top_base();
			translate([0, 0, can_hig+base_tkn+20]) 
			{
				dome_top(base_rad, 2);
			}
		}

		translate([-can_rad-can_rad*0.5, 0, -40])
			rotate([0, 0, 90])
			{
				front_wheel_ball();
				translate([20, 0, 0])
					front_wheel_leg(0);
				translate([-20, 0, 0])
					mirror([1, 0, 0])
						front_wheel_leg(1);
			}
	}

	translate([0, 40, 0])
		leg(leg_hig, leg_wid, leg_tkn, base_rad, 2);
	translate([0, -40, 0])
		mirror([0, 1, 0]) leg(leg_hig, leg_wid, leg_tkn, base_rad, 2);
}