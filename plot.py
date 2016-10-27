''' Present an interactive function explorer with slider widgets.
Scrub the sliders to change the properties of the ``sin`` curve, or
type into the title text box to update the title of the plot.
Use the ``bokeh serve`` command to run the example by executing:
    bokeh serve sliders.py
at your command prompt. Then navigate to the URL
    http://localhost:5006/sliders
in your browser.
'''
import numpy as np
import scipy.special

from bokeh.io import curdoc
from bokeh.layouts import row, widgetbox
from bokeh.models import ColumnDataSource
from bokeh.models.widgets import Slider, TextInput
from bokeh.plotting import figure

def compute_posterior(density_center):
    if -3 <= density_center <= -1:
        est = -0.25 * density_center - 0.5
        post_s = 0.4 * density_center + 1.2
        post_e = (1 - post_s) / 3.0 * 2.0
        post_l = (1 - post_s) / 3.0 

    elif density_center < -3:
        est = 0.25
        post_s = 0
        post_e = 0.667
        post_l = 0.333 

    else: 
        est = -0.25
        post_s = 0.8
        post_e = 0.067
        post_l = 0.033

    return (est, post_s, post_e, post_l)

# Set up data
equal_mu, equal_sigma   = 0, 0.1
larger_mu, larger_sigma = 0.7, 0.6
small_mu, small_sigma   = -1, 0.2
haptic_mu, haptic_sigma = 0, 0.5

prior_s = 0.8
prior_e = 0.067
prior_l = 0.033

x = np.linspace(-5, 5, 10000)

equal_pdf = 1/(equal_sigma * np.sqrt(2*np.pi)) * np.exp(-(x-equal_mu)**2 / (2*equal_sigma**2))
larger_pdf = 1/(larger_sigma * np.sqrt(2*np.pi)) * np.exp(-(x-larger_mu)**2 / (2*larger_sigma**2))
small_pdf = 1/(small_sigma * np.sqrt(2*np.pi)) * np.exp(-(x-small_mu)**2 / (2*small_sigma**2))
haptic_pdf = 1/(haptic_sigma * np.sqrt(2*np.pi)) * np.exp(-(x-haptic_mu)**2 / (2*haptic_sigma**2))

y = small_pdf

source0 = ColumnDataSource(data=dict(x=x, y=y))
source1 = ColumnDataSource(data=dict(x=[1, 1], y=[0, prior_s]))
source2 = ColumnDataSource(data=dict(x=[1.5, 1.5], y=[0, prior_e]))
source3 = ColumnDataSource(data=dict(x=[2, 2], y=[0, prior_l]))
source4 = ColumnDataSource(data=dict(x=[-0.25, -0.25], y=[0, 4.5]))

# Set up plot
plot = figure(plot_height=300, plot_width=800, title="Competitive Prior for Weight Perception", y_range=[0, 4.5],
    x_axis_label='log (Ligher-looking Heaviness / Heavier-looking Heaviness)', y_axis_label='Probability Density', tools="save")

plot.line('x', 'y', source=source0, line_color="red", line_width=3, alpha=0.7, legend="Material Density Prior")

plot.line(x, larger_pdf, line_color="green", line_width=3, alpha=0.7, legend="Larger Density Prior")
plot.line(x, equal_pdf, line_color="orange", line_width=3, alpha=0.7, legend="Equal Density Prior")
plot.line(x, haptic_pdf, line_color="black", line_width=4, alpha=0.7, legend="Haptic Input", line_dash = 'dashdot')

plot.line('x', 'y', source=source4, line_width = 3, line_dash = 'dashed', legend="Final Estimation")
# plot.legend.location = 'top_left'

posterior = figure(plot_height=300, plot_width=300, title="Posterior of Density Relationship", x_range = [0.5, 2.5], 
    x_axis_label='Competitive Prior', tools="save")
posterior.line('x', 'y', source=source1, line_width = 20, line_color="red")
posterior.line('x', 'y', source=source2, line_width = 20, line_color="orange")
posterior.line('x', 'y', source=source3, line_width = 20, line_color="green")

# Set up widgets
density_cue = Slider(title="Material Cue", value=-1.0, start=-6.0, end=0, step=0.1)

def update_data(attrname, old, new):
    # Get the current slider values
    d = density_cue.value    

    # Generate the new curve
    x = np.linspace(-5, 5, 10000)
    y = 1 / (small_sigma * np.sqrt(2*np.pi)) * np.exp(-(x-d)**2 / (2*small_sigma**2))
    source0.data = dict(x=x, y=y)

    est, post_s, post_e, post_l = compute_posterior(d)
    source1.data = dict(x=[1, 1], y=[0, post_s])
    source2.data = dict(x=[1.5, 1.5], y=[0, post_e])
    source3.data = dict(x=[2, 2], y=[0, post_l])
    source4.data = dict(x=[est, est], y=[0, 4.5])

    
density_cue.on_change('value', update_data)
# for w in [offset, amplitude, phase, freq]:
#     w.on_change('value', update_data)

# Set up layouts and add to document
inputs = widgetbox(density_cue) 


curdoc().add_root(row(inputs, width=1400))
curdoc().add_root(row(plot, posterior, width=1400))
curdoc().title = "Hierarchical Bayesian Model"