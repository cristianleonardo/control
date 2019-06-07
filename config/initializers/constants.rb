# coding: utf-8
ROLE_GROUPS = {
  'Administración': :administration,
  'Financiero': :financial,
  'Asistente Financiero': :financial_assistant,
  'Contratación': :recruitment,
  'Supervisión': :supervision,
  'Consulta': :reports
}

GENERAL_SOURCE_TYPES = {
  'Rubro': :rubro,
  'PGEI': :pgei,
}

RESOURCE_TYPES = {
  'Recursos Propios': :rp,
  'Recursos Externos': :re
}

SOURCE_TYPES = {
  'RP': :rp,
  'PAEI': :paei,
}

IDENTIFICATION_TYPES = {
 "Número de identificación tributario" => :NIT,
 "Cédula ciudadanía" => :CC,
 "Cédula de extranjería" => :CE,
 "Carné diplomático" => :CD,
 "Pasaporte" => :PA,
 "Registro civil" => :RC,
 "Tarjeta de identidad" => :TI,
 "Adulto sin identificar" => :AS,
 "Menor sin identificar" => :MS,
 "Certificado de nacido vivo" => :NV,
 "Salvoconducto" => :SC,
 "Pasaporte de la ONU" => :PR,
 "Número Unico de identificación" => :NU
}

CONTRACT_STATES = {
  "En proceso contractual" => :PC,
  "En ejecución" => :EJ,
  "Suspendido" => :SU,
  "Terminado" => :TR,
  "Liquidado" => :LI
}

CONTRACT_MODE = {
 "Contratación Directa" => :CD,
 "Mínima Cuantía" => :MC,
 "Concurso de Méritoss" => :CM,
 "Licitación Pública" => :LP,
 "Selección Abreviada" => :SA,
 "Subasta Inversa" => :SI
}

ADDITION_TYPE = {
 "Otro Sí" => :OS,
 "Suspensión" => :SU,
 "Reinicio" => :RE
}

CERTIFICATE_STATE = {
 "Vigente" => :Vigente,
 "Vencido" => :Vencido,
}

PAYMENT_TYPE = {
 "Factura" => :FAC,
 "Cuenta de Cobro" => :CTA
}

SOURCE_TYPE = {
  "Recursos Propios" => :RP,
  "Recursos Externos" => :PAEI
}

CERTIFICATE_TYPE = {
  "CDP" => :CDP,
  "CDR" => :CDR
}
DOCUMENT_TYPE = {
  "Acta de comité" => :ACT,
  "Carta de viabilidad" => :LTR
}
DOCUMENT_SUB_TYPE = {
  "Nacional" => :NAC,
  "Regional" => :REG
}
