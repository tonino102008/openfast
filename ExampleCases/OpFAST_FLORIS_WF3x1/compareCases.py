import matplotlib
matplotlib.use('AGG')
import fast_io
import numpy as np
import sys, os, palettable
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1.axes_divider import make_axes_area_auto_adjustable
plt.style.use('twoColumn_legendabove')


def plotTwoTurbineOutput(d1x,d1y,case1Label,d2x,d2y,case2Label,chanName,chanUnit=''):
    
    fig = plt.figure()
    ax = plt.axes([0,0,1,1])
    ax.set_color_cycle(palettable.colorbrewer.qualitative.Dark2_8.mpl_colors)
    plt.plot(d1x,d1y,label=case1Label)
    plt.plot(d2x,d2y,label=case2Label)
    plt.xlabel('Time (s)')
    plt.ylabel('{} ({})'.format(chanName,chanUnit))
    plt.legend(loc=0)
    make_axes_area_auto_adjustable(ax)
    plt.savefig('compare{}_{}_{}.png'.format(case1Label,case2Label,chanName))
    plt.close(fig)


def plotNTurbineOutput(nTurbines, dx, dy, caseLabels, chanName, chanUnit=''):
    
    fig, ax = plt.subplots()
    ax.set_color_cycle(palettable.colorbrewer.qualitative.Dark2_8.mpl_colors)
    for i in range(nTurbines):
        plt.plot(dx[i],dy[i],label=caseLabels[i])
    plt.xlabel('Time (s)')
    plt.ylabel('{} ({})'.format(chanName,chanUnit))
    plt.legend(loc='lower center',ncol=2,bbox_to_anchor=(0.435, 1.01))
    plt.tight_layout(rect=[0,0,1,0.8])
    plt.savefig('compare_{}.png'.format(chanName))
    plt.close(fig)
    

def loadFiles(case, fileType='binary'):

    if (fileType == 'binary'):
        try:
            d1, i1 = fast_io.load_binary_output('{}.outb'.format(case))
        except:
            print "Problem reading file {}.outb".format(case)

        return [d1, i1]
    else:
        try:
            print '{}.out'.format(case)
            d1, i1 = fast_io.load_ascii_output('{}.out'.format(case))
        except:
            print "Problem reading file {}.out".format(case)

        return [d1,i1]

def compareCases(fileType='binary'):

    data = []
    dInfo = []

    cases = ['t1.T1', 't2.T2', 't3.T3']
    caseLabels = [r'$dP_{min}/dt = 0.005$', r'$dP_{min}/dt = 0.01$', r'$dP_{min}/dt = 0.015$']
    
    for j,jc in enumerate(cases):
        d, i = loadFiles(cases[j],fileType)
        data.append(d)
        dInfo.append(i)

    nChannels = np.size(data[0],1)
    print nChannels
    for j in range(1,nChannels):
        dx = []
        dy = []
        for i,ic in enumerate(cases):
            dx.append(data[i][:,0])
            dy.append(data[i][:,j])
        plotNTurbineOutput(len(cases), dx, dy, caseLabels, dInfo[0]['attribute_names'][j])
        
if __name__=="__main__":
    
    compareCases()
