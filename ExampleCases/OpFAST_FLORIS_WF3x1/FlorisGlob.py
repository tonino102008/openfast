import floris.tools as wfct
import floris.tools.visualization as vis
import floris.tools.cut_plane as cp
import numpy as np
from scipy.interpolate import griddata
from scipy.interpolate import RectBivariateSpline

fi = wfct.floris_utilities.FlorisInterface("NREL5MW_INPUT.json")
flowData = None
flag = 0 #This flag tells me if to recompute flow field or not (Am I in the same time step, same turbine???)
funint = None #Interpolating on x-y flow field
zlow = 0 # z value indexes to understanf if i need to interpolate on z
zhigh = 0
nTurb = 3
nCount = 0
funList = None

def InterpWindFun(flowdata):
    zz = np.array(sorted(np.unique(flowdata.z)))
    for i in range(len(zz)):
        zz_mask = flowdata.z == zz[i]
        xx = flowdata.x[zz_mask]
        yy = flowdata.y[zz_mask]
        um = flowdata.u[zz_mask]
        xx1 = np.unique(xx)
        yy1 = np.unique(yy)
        xxm, yym = np.meshgrid(xx1, yy1)
        if i == 0:
            fllist = np.array(griddata(np.column_stack([xx, yy]), um, (xxm.flatten(), yym.flatten()), method='cubic'))
        else:
            fllist = np.vstack((fllist, np.array(griddata(np.column_stack([xx, yy]), um, (xxm.flatten(), yym.flatten()), method='cubic'))))
    
    return fllist

def WindInt(pos, flist, flowdata):
    zz = np.array(sorted(np.unique(flowdata.z)))
    idzlow = (np.abs(zz - pos[2])).argmin()
    idzhigh = idzlow + 1
    zlow = zz[idzlow]
    zhigh = zz[idzhigh]
    u_mesh_int = flist[idzlow] + (flist[idzhigh]-flist[idzlow])*(pos[2]-zlow)/(zhigh-zlow)

    zz_mask = flowdata.z == zz[0] # USEFUL ONLY FOR INDICES
    xx = flowdata.x[zz_mask]
    yy = flowdata.y[zz_mask]
    xx1 = np.unique(xx)
    yy1 = np.unique(yy)

    nearest_idxx = (np.abs(xx - pos[0])).argmin()
    nearest_idxxa = nearest_idxx + 1
    nearest_idyy = (np.abs(yy - pos[1])).argmin()
    nearest_idyya = nearest_idyy + len(xx1) + 1
    nn = np.isclose(xx, xx[nearest_idxx])
    nn1 = np.isclose(xx, xx[nearest_idxxa])
    mm  = np.isclose(yy, yy[nearest_idyy])
    mm1  = np.isclose(yy, yy[nearest_idyya])
    ind = np.logical_and(nn,mm)
    ind2 = np.logical_and(nn1,mm)
    ind3 = np.logical_and(nn,mm1)
    ind1 = np.logical_and(nn1,mm1)
    funInt = RectBivariateSpline([float(xx[ind]), float(xx[ind1])], [float(yy[ind]), float(yy[ind1])], np.array([[u_mesh_int[ind], u_mesh_int[ind2]], [u_mesh_int[ind3], u_mesh_int[ind1]]]), kx = 1, ky = 1)
    out = np.array([funInt(pos[0], pos[1])[0][0], 0, 0])

    return out, xx, yy, len(xx1)
    
#WIND_SPEED, T.I. and else are taken from json file, but i may change them if i wanted to