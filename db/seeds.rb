#coding: utf-8
User.create(firstname: "Control", lastname: "(administration)", email: "control_administration@ufps.edu.co", password: '0987654321', password_confirmation: '0987654321', role_group: :administration)
User.create(firstname: "Control", lastname: "(financianciero)", email: "control_financial@ufps.edu.co", password: '0987654321', password_confirmation: '0987654321', role_group: :financial)
User.create(firstname: "Control", lastname: "(contratación)", email: "control_recruitment@ufps.edu.co", password: '0987654321', password_confirmation: '0987654321', role_group: :recruitment)
User.create(firstname: "Control", lastname: "(supervisión)", email: "control_supervision@ufps.edu.co", password: '0987654321', password_confirmation: '0987654321', role_group: :supervision)
User.create(firstname: "Control", lastname: "(reportes)", email: "control_reports@ufps.edu.co", password: '0987654321', password_confirmation: '0987654321', role_group: :reports)

ContractType.create(abbreviation: "CG", name: "Costo global")
ContractType.create(abbreviation: "TM", name: "Tiempo y materiales")
ContractType.create(abbreviation: "PU", name: "Precios Unitarios")
ContractType.create(abbreviation: "PA", name: "Precio Alzado")
ContractType.create(abbreviation: "ADM", name: "Administracion")

WorkType.create(name: "Clase A", description: "Estructura de soporte en acero")
WorkType.create(name: "Clase B", description: "Estructura de soporte en hormigon armado")
WorkType.create(name: "Clase C", description: "Estructura de soporte en ladrillo")
WorkType.create(name: "Clase D", description: "Estructura de soporte de bloques o de piedra")
WorkType.create(name: "Clase E", description: "Estructura de soporte en madera")
WorkType.create(name: "Clase F", description: "Construcciones en adobe, tierra u otros materiales")

Input.create(name: "Cemento", metrics: "Kg", input_type: "Material")
Input.create(name: "Volqueta", metrics: "Unidad", input_type: "Equipo")
Input.create(name: "Ladrillos", metrics: "Kg", input_type: "Material")
Input.create(name: "baldosa", metrics: "m2", input_type: "Material")
