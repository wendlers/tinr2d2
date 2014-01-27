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
can_rad=51.5;				// radius of tin can
							// 51.5 is for lavazza espresso can
can_rad_inner=can_rad-4;

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
// show_full_robot(1);
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

// print_inlay();
// print_led_panel();
print_speaker_box();

/* some test views of single parts */

// led_panel();

// speaker_box();

// inlay_base(1);

// inlay(can_hig, 94/2, base_tkn, 1);

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

module battery1()
{
	// battery1_expensive();
	battery1_cheap();
}

module battery2()
{
	// battery2_expensive();
	battery2_cheap();
}

module battery1_expensive()
{
	w=34;
	h=64;
	t=13;

	translate([0, 15, -(76.5-h)/2-4])
		cube([w, t, h], center=true);
}

module battery2_expensive()
{
	w=31;
	h=52;
	t=10;

	translate([0, 28, -(76.5-h)/2-4])
		cube([w, t, h], center=true);
}

// cheap pollin LiPo battery
module battery1_cheap()
{
	w=30;
	h=50;
	t=11;

	translate([0, 15, -(76.5-h)/2-4])
		cube([w, t, h], center=true);
}

// cheap pollin LiPo battery
module battery2_cheap()
{
	w=30;
	h=50;
	t=11;

	translate([0, 28, -(76.5-h)/2-4])
		cube([w, t, h], center=true);
}

module ext_board()
{
	w=51.5;
	h=76.5;
	t=2;

	union()
	{
		// Ext. board
		translate([0, -9, 0])
			cube([w, t, h], center=true);
	
		// BTBee
		translate([0, -9 - 6, h/2 - 34/2])
			cube([24, 12, 34], center=true);

		// Motor controller
		translate([-10, -9 - 2.25, -10])
			cube([20, 4.5, 20], center=true);

		// Step-Up/Down
		translate([+15, -9 - 2.25, -10])
			cube([12, 4.5, 17], center=true);
	}
}

module prop_qs()
{
	w=51.5;
	h=76.5;
	t=2;

	union()
	{
		// Propeller QuickStart board
		cube([w, t, h], center=true);

		// Ext. connector
		translate([w/2-2.5-3, -4, 0])
			cube([5, 8, 50], center=true);

		// USB connector
		translate([0, -2.25, h/2-3.75])
			cube([7.5, 4.5, 9], center=true);
	}
}

module inlay(hig, rad, tkn, showboard)
{
	w1=51.5 + 5;
	w2=51.5 - 4;
	h1=83;
	h2=77;
	t=2;

	union()
	{

		difference()
		{	
			cylinder(h=tkn, r=rad);
/*
			translate([0, 0, -2])
				rotate([0, 0, 180])
					bottop_cylseg(rad, 4*tkn);

			translate([0, 0, -2])
				rotate([0, 0, 270])
					bottop_cylseg(rad, 4*tkn);
*/
			translate([0, 0, -2])
				rotate([0, 0, 90])
					bottop_cylseg(rad, 4*tkn);

			translate([0, 0, -2])
				rotate([0, 0, 0])
					bottop_cylseg(rad, 4*tkn);

		}

		translate([0, 0, h1/2])
		{
			difference()
			{
				cube([w1, 10, h1], center=true);

				translate([0,0,h1-h2])
					cube([w1 - (w1 - w2), 10, h2], center=true);

				translate([0,0,h1-h2-t])
					prop_qs();			
			}

			difference()
			{
				translate([0, 15, -h1/2 + 15])
					cube([34, 14, 30], center=true);	

				translate([0, 0, tkn+1])
				{
					battery1();
				}
				translate([0, 40, -25])
					rotate([90, 0, 0])
						cylinder(r=10, h=40);
				translate([9, 14.5, -h2/2-2*tkn])
					cylinder(r=4, h=4);
				mirror([1, 0, 0])
					translate([9, 14.5, -h2/2-2*tkn])
						cylinder(r=4, h=4);
				translate([-20, 15, -18])
					rotate([0, 90, 0])
						cylinder(r=3, h=40);
				translate([-20, 15, -26])
					rotate([0, 90, 0])
						cylinder(r=3, h=40);
				translate([-20, 15, -34])
					rotate([0, 90, 0])
						cylinder(r=3, h=40);
			}
			difference()
			{
				translate([0, 28, -h1/2 + 15])
					cube([34, 14, 30], center=true);	

				translate([0, 0, tkn+1])
				{
					battery2();
				}
				translate([0, 40, -25])
					rotate([90, 0, 0])
						cylinder(r=10, h=40);
				translate([9, 28.5, -h2/2-2*tkn])
					cylinder(r=3, h=4);
				mirror([1, 0, 0])
					translate([9, 28.5, -h2/2-2*tkn])
						cylinder(r=3, h=4);
				translate([-20, 28, -18])
					rotate([0, 90, 0])
						cylinder(r=2.5, h=40);
				translate([-20, 28, -26])
					rotate([0, 90, 0])
						cylinder(r=2.5, h=40);
				translate([-20, 28, -34])
					rotate([0, 90, 0])
						cylinder(r=2.5, h=40);
			}

		}
	}

	if(showboard == 1)
	{
		translate([0,0,h1/2 + (h1-h2-t)])
		{
			prop_qs();
			ext_board();
			battery1();
			battery2();
		}
	}
}

module inlay_base(showboard)
{
	translate([45, 0, -base_tkn - can_tkn])
		rotate([0, -bod_rot, 0])	
			rotate([0, bod_rot, 0])
			{
				difference() {

					translate([-45, 0, 0])
					{			
						translate([0, 0, base_tkn + can_tkn])
							rotate([0, 0, 270])
								inlay(can_hig, can_rad_inner, base_tkn, showboard);
					}

					translate([-can_rad-can_rad*0.5, 0, -20])
						rotate([0, 0, 90])
							front_wheel_drill_holes();
				}
		}	
}

module print_inlay()
{
	inlay_base(0);
	// inlay(can_hig, can_rad_inner, base_tkn, 0);
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
		cylinder(h=20, r=1.9, center=true);
	translate([8, +5, 19])
		cylinder(h=20, r=1.9, center=true);

	mirror([1, 0, 0])
	{
		translate([8, -5, 19])
			cylinder(h=20, r=1.9, center=true);
		translate([8, +5, 19])
			cylinder(h=20, r=1.9, center=true);
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
		{
			difference()
			{
				cylinder(h=tkn, r=drad);

				// hole for the on/off switch
				cube([22, 20.9, 20], center=true);
				translate([0, rad/2, -tkn])
					cylinder(h=tkn*4, r=4);
				translate([0, -rad/2, -tkn])
					cylinder(h=tkn*4, r=4);
			}
		}
	
		translate([0, 0, rad*0.6-2*tkn]) 
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
							cylinder(h=20, r=8.5);
				}
		}
	}
}

module led_panel()
{
	w1 = 40;
	w2 = 30;
	t1 = 15;
	t2 = 2;

	rotate([0, 0, 90])
	difference()
	{

		union()
		{
			translate([0, can_rad, can_hig - w1 - t1])
			{
				difference() 
				{
					cube([w1, t1, w2], center=true);
					translate([0, -t2, 0])
						cube([w1 - 2 * t2, t1 - t2, w2 - 2 * t2], center=true);
				}
			}

			translate([w1 / 2 - 4, can_rad + t1 / 2, can_hig - w1 - t1 - 4 + w2 / 2])
				rotate([90, 0, 0])
					cylinder(h=t1 - 1, r=4);
			mirror([1, 0, 0])
				translate([w1 / 2 - 4, can_rad + t1 / 2, can_hig - w1 - t1 - 4 + w2 / 2])
					rotate([90, 0, 0])
						cylinder(h=t1 - 1, r=4);

			translate([w1 / 2 - 4, can_rad + t1 / 2, can_hig - w1 - t1 + 4 - w2 / 2])
				rotate([90, 0, 0])
					cylinder(h=t1 - 1, r=4);
			mirror([1, 0, 0])
				translate([w1 / 2 - 4, can_rad + t1 / 2, can_hig - w1 - t1 + 4 - w2 / 2])
					rotate([90, 0, 0])
						cylinder(h=t1 - 1, r=4);
		}

		intersection() 
		{
			translate([0, 0, can_tkn])
				cylinder(h=can_hig, r=can_rad);
			translate([0, can_rad, can_hig - w1 - t1])
				cube([w1, t1, w2], center=true);
		}

		// holes for all the LEDs forming a mouth
		translate([0, can_rad + t1, can_hig - w1 - t1])
			rotate([90, 0, 0])
				cylinder(h=20, r=1.65);
		translate([+7, can_rad + t1, can_hig - w1 - t1])
			rotate([90, 0, 0])
				cylinder(h=20, r=1.65);
		translate([-7, can_rad + t1, can_hig - w1 - t1])
			rotate([90, 0, 0])
				cylinder(h=20, r=1.65);

		translate([+14, can_rad + t1, can_hig - w1 - t1 + 3.5])
			rotate([90, 0, 0])
				cylinder(h=20, r=1.65);
		translate([-14, can_rad + t1, can_hig - w1 - t1 + 3.5])
			rotate([90, 0, 0])
				cylinder(h=20, r=1.65);

		translate([+14, can_rad + t1, can_hig - w1 - t1 - 3.5])
			rotate([90, 0, 0])
				cylinder(h=20, r=1.65);
		translate([-14, can_rad + t1, can_hig - w1 - t1 - 3.5])
			rotate([90, 0, 0])
				cylinder(h=20, r=1.65);

		// drill holes
		translate([w1 / 2 - 4, can_rad + t1 / 2 + 1, can_hig - w1 - t1 - 4 + w2 / 2])
			rotate([90, 0, 0])
				cylinder(h=t1, r=1.7);
		mirror([1, 0, 0])
			translate([w1 / 2 - 4, can_rad + t1 / 2 + 1, can_hig - w1 - t1 - 4 + w2 / 2])
				rotate([90, 0, 0])
					cylinder(h=t1, r=1.7);
	
		translate([w1 / 2 - 4, can_rad + t1 / 2 + 1, can_hig - w1 - t1 + 4 - w2 / 2])
			rotate([90, 0, 0])
				cylinder(h=t1, r=1.7);
		mirror([1, 0, 0])
			translate([w1 / 2 - 4, can_rad + t1 / 2 + 1, can_hig - w1 - t1 + 4 - w2 / 2])
				rotate([90, 0, 0])
					cylinder(h=t1, r=1.7);
	}
}

module print_led_panel()
{
	translate([can_rad, 0, can_rad + 7.5])
		rotate([0, -90, 0])	
			led_panel();
}

module speaker_box()
{
	w1 = 40;
	w2 = 30;
	t1 = 15;
	t2 = 2;

	rotate([0, 0, 90])
	difference()
	{

		union()
		{
			translate([0, can_rad, can_hig - w1 - t1])
			{
				difference() 
				{
					cube([w1, t1, w2], center=true);
					translate([0, -t2, 0])
						cube([w1 - 2 * t2, t1 - t2, w2 - 2 * t2], center=true);
				}
			}

			translate([0, can_rad + t1/2, can_hig - w1 - t1])
			{
				difference()
				{
					rotate([90, 0, 0])
						cylinder(h=t1 - 1, r=(20.5 + t2)/2);
	
					rotate([90, 0, 0])
						cylinder(h=t1 - 1, r=20.5/2);
				}
			}

			translate([w1 / 2 - 4, can_rad + t1 / 2, can_hig - w1 - t1 - 4 + w2 / 2])
				rotate([90, 0, 0])
					cylinder(h=t1 - 1, r=4);

			mirror([1, 0, 0])
				translate([w1 / 2 - 4, can_rad + t1 / 2, can_hig - w1 - t1 - 4 + w2 / 2])
					rotate([90, 0, 0])
						cylinder(h=t1 - 1, r=4);

			translate([w1 / 2 - 4, can_rad + t1 / 2, can_hig - w1 - t1 + 4 - w2 / 2])
				rotate([90, 0, 0])
					cylinder(h=t1 - 1, r=4);

			mirror([1, 0, 0])
				translate([w1 / 2 - 4, can_rad + t1 / 2, can_hig - w1 - t1 + 4 - w2 / 2])
					rotate([90, 0, 0])
						cylinder(h=t1 - 1, r=4);
		}

		intersection() 
		{
			translate([0, 0, can_tkn])
				cylinder(h=can_hig, r=can_rad);
			translate([0, can_rad, can_hig - w1 - t1])
				cube([w1, t1, w2], center=true);
		}

		// drill holes
		translate([w1 / 2 - 4, can_rad + t1 / 2 + 1, can_hig - w1 - t1 - 4 + w2 / 2])
			rotate([90, 0, 0])
				cylinder(h=t1, r=1.7);
		mirror([1, 0, 0])
			translate([w1 / 2 - 4, can_rad + t1 / 2 + 1, can_hig - w1 - t1 - 4 + w2 / 2])
				rotate([90, 0, 0])
					cylinder(h=t1, r=1.7);
	
		translate([w1 / 2 - 4, can_rad + t1 / 2 + 1, can_hig - w1 - t1 + 4 - w2 / 2])
			rotate([90, 0, 0])
				cylinder(h=t1, r=1.7);
		mirror([1, 0, 0])
			translate([w1 / 2 - 4, can_rad + t1 / 2 + 1, can_hig - w1 - t1 + 4 - w2 / 2])
				rotate([90, 0, 0])
					cylinder(h=t1, r=1.7);

		// riffles for speaker
		translate([w1 / 2 - 20, can_rad + t1 / 2 -1, can_hig - w1 - t1 - 4 + w2 / 2 - 6])
			cube([15, t2*2, t2], center=true);
		translate([w1 / 2 - 20, can_rad + t1 / 2 -1, can_hig - w1 - t1 - 4 + w2 / 2 - 11])
			cube([19, t2*2, t2], center=true);
		translate([w1 / 2 - 20, can_rad + t1 / 2 -1, can_hig - w1 - t1 - 4 + w2 / 2 - 16])
			cube([15, t2*2, t2], center=true);
	}
}

module print_speaker_box()
{
	translate([can_rad, 0, can_rad + 7.5])
		rotate([0, -90, 0])	
			speaker_box();
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
			{
				can(can_hig, can_rad, can_tkn);
			}
			else
			{
				inlay_base(1);
			}
			led_panel();
			translate([0, 0, -40])
				speaker_box();
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
			translate([0, 0, 25])
				inlay_base(0);

			led_panel();

			translate([0, 0, -40])
				speaker_box();
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
