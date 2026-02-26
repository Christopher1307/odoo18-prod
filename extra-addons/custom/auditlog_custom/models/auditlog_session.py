from odoo import models, fields, api

class AuditlogHttpSession(models.Model):
    _inherit = 'auditlog.http.session'

    # Cambiamos el campo para que sea computado
    x_fecha_accion = fields.Datetime(
        string='Fecha de acción',
        compute='_compute_x_fecha_accion',
        store=True,       # Para que se guarde en DB y puedas filtrar/ordenar
        readonly=False    # Para que permita edición manual si quieres
    )
    x_accion_usuario = fields.Char(
        string='Acción de usuario'
    )

    @api.depends('create_date')
    def _compute_x_fecha_accion(self):
        for record in self:
            if not record.x_fecha_accion:
                record.x_fecha_accion = record.create_date
            else:
                # Si ya tiene valor, mantenemos el que tiene
                record.x_fecha_accion = record.x_fecha_accion