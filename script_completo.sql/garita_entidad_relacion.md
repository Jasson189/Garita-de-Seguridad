# Entidad Relación - Sistema Garita de Seguridad

## Entidades principales

1. **roles**
   - Define los permisos generales del sistema.
   - Ejemplos: Administrador, Agente, Vecino.

2. **usuarios**
   - Guarda los usuarios que pueden iniciar sesión.
   - Se relaciona con roles.

3. **viviendas**
   - Guarda las casas o apartamentos de la residencial.

4. **vecinos**
   - Guarda los residentes.
   - Cada vecino pertenece a una vivienda.
   - Puede tener un usuario asociado.

5. **visitantes**
   - Guarda las personas que llegan a la garita.
   - Un visitante puede tener varias visitas.

6. **visitas**
   - Es la entidad central.
   - Registra ingreso, salida, placa, foto, vecino visitado, vivienda y agente.

7. **evidencias_fotograficas**
   - Guarda evidencias adicionales.
   - Puede registrar foto de visitante o foto de placa.

## Relaciones

- Un rol puede tener muchos usuarios.
- Un usuario puede registrar muchas visitas.
- Una vivienda puede tener muchos vecinos.
- Una vivienda puede recibir muchas visitas.
- Un vecino puede recibir muchas visitas.
- Un visitante puede realizar muchas visitas.
- Una visita puede tener muchas evidencias fotográficas.

## Relación central

La tabla **visitas** une:

- visitante
- vecino
- vivienda
- usuario agente
- placa
- foto
- fecha/hora de ingreso
- fecha/hora de salida
- estado de visita

## Reglas importantes

- Cada vecino debe tener un código único.
- Una visita debe tener visitante, vecino, vivienda y agente.
- Una visita activa puede pasar a finalizada al registrar salida.
- La foto puede ser opcional.
- La placa puede ser opcional, pero se recomienda registrarla.
