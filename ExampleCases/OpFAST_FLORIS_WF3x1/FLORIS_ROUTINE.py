# Copyright 2019 NREL

# Licensed under the Apache License, Version 2.0 (the "License"); you may not use
# this file except in compliance with the License. You may obtain a copy of the
# License at http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

# See read the https://floris.readthedocs.io for documentation

import floris.tools as wfct
import floris.tools.visualization as vis
import floris.tools.cut_plane as cp
import numpy as np
from scipy.interpolate import griddata
from scipy.interpolate import RectBivariateSpline
import FlorisGlob

def FLORIS_ROUTINE():

    FlorisGlob.fi.calculate_wake()
    FlorisGlob.flowData = FlorisGlob.fi.get_flow_data()
    funList = FlorisGlob.InterpWindFun(FlorisGlob.flowData)
    print("FLORIS ROUTINE")
    
    return funList.flatten().astype(np.float64)

def FLORIS_ROUTINE_SHAPE():
    print("FLORIS ROUTINE SHAPE")
    FlorisGlob.fi.calculate_wake()
    FlorisGlob.flowData = FlorisGlob.fi.get_flow_data()
    FlorisGlob.funList = FlorisGlob.InterpWindFun(FlorisGlob.flowData)

    return np.asarray(np.shape(FlorisGlob.funList), dtype=np.float64).reshape(2,)

def xxdom():
    #FlorisGlob.fi.calculate_wake()
    #FlorisGlob.flowData = FlorisGlob.fi.get_flow_data()
    FlorisGlob.funList = FlorisGlob.InterpWindFun(FlorisGlob.flowData)
    flowdata = FlorisGlob.flowData
    zz = np.array(sorted(np.unique(flowdata.z)))

    zz_mask = flowdata.z == zz[0] # USEFUL ONLY FOR INDICES
    xx = flowdata.x[zz_mask]
    print("FLORIS xxdom")

    return np.hstack((xx, len(xx))).astype(np.float64)

def zzdom():
    #FlorisGlob.fi.calculate_wake()
    #FlorisGlob.flowData = FlorisGlob.fi.get_flow_data()
    FlorisGlob.funList = FlorisGlob.InterpWindFun(FlorisGlob.flowData)
    flowdata = FlorisGlob.flowData
    zz = np.array(sorted(np.unique(flowdata.z)))
    print("FLORIS zzdom")

    zz_mask = flowdata.z == zz[0] # USEFUL ONLY FOR INDICES

    return np.hstack((zz, len(zz))).astype(np.float64)

def yydom():
    #FlorisGlob.fi.calculate_wake()
    #FlorisGlob.flowData = FlorisGlob.fi.get_flow_data()
    FlorisGlob.funList = FlorisGlob.InterpWindFun(FlorisGlob.flowData)
    flowdata = FlorisGlob.flowData
    zz = np.array(sorted(np.unique(flowdata.z)))
    print("FLORIS yydom")

    zz_mask = flowdata.z == zz[0] # USEFUL ONLY FOR INDICES
    yy = flowdata.y[zz_mask]

    return np.hstack((yy, len(yy))).astype(np.float64)


def xx1len():
    #FlorisGlob.fi.calculate_wake()
    #FlorisGlob.flowData = FlorisGlob.fi.get_flow_data()
    FlorisGlob.funList = FlorisGlob.InterpWindFun(FlorisGlob.flowData)
    flowdata = FlorisGlob.flowData
    zz = np.array(sorted(np.unique(flowdata.z)))
    print("FLORIS xx1len")

    zz_mask = flowdata.z == zz[0] # USEFUL ONLY FOR INDICES
    xx = flowdata.x[zz_mask]
    xx1 = np.unique(xx)
    nTurbine = 3
    xlayout = np.array([0.0, 300, 500])
    ylayout = np.array([0.0, 35, -60])
    layout = np.hstack((xlayout, ylayout))

    return np.hstack(([len(xx1), nTurbine], layout)).astype(np.float64)

#for i in range(len(fi.floris.farm.turbines[0].power_thrust_table['power'])):
#    fi.floris.farm.turbines[0].power_thrust_table['power'][i] = fi.floris.farm.turbines[0].power_thrust_table['power'][i] + 100
#    fi.floris.farm.turbines[1].power_thrust_table['power'][i] = fi.floris.farm.turbines[0].power_thrust_table['power'][i] + 100
#    fi.floris.farm.turbines[2].power_thrust_table['power'][i] = fi.floris.farm.turbines[0].power_thrust_table['power'][i] + 100
 #   fi.floris.farm.turbines[3].power_thrust_table['power'][i] = fi.floris.farm.turbines[0].power_thrust_table['power'][i] + 100
#fi.floris.farm.flow_field.wind_speed = 8
#print(FLORIS_ROUTINE().dtype)