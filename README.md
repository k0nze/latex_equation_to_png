**SYNTAX**:  
`equation_to_png.sh [OPTIONS] LATEX_CODE OUTPUT_FILE`

**OPTIONS**:  
`--help, -h: shows this help text`

**LATEX_CODE**:  
`LaTeX code without $..$, $$..$$ or \[\]`

**OUTPUT_FILE**:  
`path to output file (PNG)`


Example:
========
`./latex_equation_to_png.sh '\vec{E}(\vec{r}_0) = \frac{1}{4\pi\varepsilon_0} \iiint \rho(\vec{r}) \frac{\vec{r}_0-\vec{r}}{\left|\vec{r}-\vec{r}_0\right|^3} \mathrm dV' e-field.png`
