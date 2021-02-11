# -*- mode: yaml -*-
#
# C++ glue-code for OpenFAST - Example input file
#

#Total number of turbines in the simulation
nTurbinesGlob: 3
#Enable debug outputs if set to true
debug: False
#The simulation will not run if dryRun is set to true
dryRun:  False
#Flag indicating whether the simulation starts from scratch or restart
simStart: init # init/trueRestart/restartDriverInitFAST
#Start time of the simulation
tStart:  0.0
#End time of the simulation. tEnd <= tMax
tEnd:    1301.0
#Max time of the simulation
tMax:    1301.0
#Time step for FAST. All turbines should have the same time step.
dtFAST:  0.005
#Restart files will be written every so many time steps
nEveryCheckPoint: 160000
#
superController: True
#
scLibFile: "./libsupercontroller.so"
#
numScInputs: 4
#
numScOutputs: 1

Turbine0:
  #The position of the turbine base for actuator-line simulations
  turbine_base_pos: [ 0.0, 0.0, 0.0 ]
  #The number of actuator points along each blade for actuator-line simulations
  num_force_pts_blade: 0
  #The number of actuator points along the tower for actuator-line simulations.
  num_force_pts_tower: 0
  #The checkpoint file for this turbine when restarting a simulation
  restart_filename: "banana1"
  #The FAST input file for this turbine
  FAST_input_filename: "t1.fst"
  #A unique turbine id for each turbine
  turb_id:  1

Turbine1:
  turbine_base_pos: [ 700.0, 0.0, 0.0 ]
  num_force_pts_blade: 0
  num_force_pts_tower: 0
  restart_filename: "banana2"
  FAST_input_filename: "t2.fst"
  turb_id:  2

Turbine2:
  turbine_base_pos: [ 1200.0, 0.0, 0.0 ]
  num_force_pts_blade: 0
  num_force_pts_tower: 0
  restart_filename: "banana3"
  FAST_input_filename: "t3.fst"
  turb_id:  3
