{
    'name': 'Auditlog Custom Fields',
    'version': '1.0',
    'category': 'Tools',
    'summary': 'Añade campos personalizados a las sesiones de auditlog',
    'depends': ['auditlog'],
    'data': [
        'views/auditlog_session_views.xml',
    ],
    'installable': True,
    'application': False,
}