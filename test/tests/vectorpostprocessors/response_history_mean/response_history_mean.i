[Mesh]
  [./generate]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 3
    ny = 3
  [../]
  [./add_bnd]
    type = ExtraNodesetGenerator
    input = generate
    new_boundary = 'bnd'
    nodes = '2 10'
  [../]
[]

[Variables]
  [./u]
  [../]
[]

[Kernels]
  [./diff]
    type = Diffusion
    variable = u
  [../]
  [./time]
    type = TimeDerivative
    variable = u
  [../]
[]

[BCs]
  [./left]
    type = DirichletBC
    variable = u
    boundary = left
    value = 0
  [../]
  [./right]
    type = DirichletBC
    variable = u
    boundary = right
    value = 1
  [../]
[]

[AuxVariables]
  [./accel_x]
  [../]
  [./proc_id]
    family = MONOMIAL
    order = CONSTANT
  [../]
[]

[AuxKernels]
  [./accel_x]
    type = FunctionAux
    function = t*t
    variable = accel_x
    execute_on = 'initial timestep_end'
  [../]
  [./proc]
    type = ProcessorIDAux
    variable = proc_id
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 5
  dt = 1
[]

[Outputs]
  [./out]
    type = CSV
    execute_on = 'final'
  [../]
[]

[VectorPostprocessors]
  [./disp_nodes]
    type = ResponseHistoryBuilder
    variables = 'u'
    nodes = '2 6 10'
  [../]
  [./disp_mean]
    type = ResponseHistoryMean
    response_history = disp_nodes
    outputs = out
  [../]
[]
