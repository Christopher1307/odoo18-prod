from odoo import models, fields

class AuditlogHttpSession(models.Model):
    _inherit = 'auditlog.http.session'

    x_fecha_accion = fields.Datetime(
        string='Fecha', 
        default=fields.Datetime.now
    )
    x_accion_usuario = fields.Char(
        string='Acción'
    )