# -*- coding: utf-8 -*-

import os
import dotenv
from django.utils.translation import gettext_lazy as _
from openstack_dashboard.settings import HORIZON_CONFIG

dotenv.load_dotenv("/openstack.env")
for key in os.environ:
	if key.startswith("PWD_"):
		os.unsetenv(key)

DEBUG = False
ALLOWED_HOSTS = ['*']
LOCAL_PATH = '/tmp'
SECRET_KEY = '837b135b201d98f1921c5c138d0ab549'
CACHES = {
	'default': {
		'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
		'LOCATION': os.getenv("SRV_MEMCACHED"),
	},
}
SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
#EMAIL_BACKEND = 'django.core.mail.backends.dummy.EmailBackend'
#EMAIL_HOST = 'classfun.cn'
#EMAIL_PORT = 25
#EMAIL_HOST_USER = ''
#EMAIL_HOST_PASSWORD = ''
LANGUAGE_CODE = 'zh_Hans'
OPENSTACK_HOST = os.getenv("API_HOST")
OPENSTACK_KEYSTONE_URL = "%s/service/keystone/v3" % os.getenv("SRV_API")
OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
# OPENSTACK_KEYSTONE_DOMAIN_DROPDOWN = True
POLICY_FILES = {
}
OPENSTACK_API_VERSIONS = {
	"identity": 3,
	"image": 2,
	"volume": 3,
}
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"
TIME_ZONE = "Asia/Shanghai"
LOGGING = {
	'version': 1,
	'disable_existing_loggers': False,
	'formatters': {
		'console': {
			'format': '%(levelname)s %(name)s %(message)s'
		},
		'operation': {
			'format': '%(message)s'
		},
	},
	'handlers': {
		'null': {
			'level': 'DEBUG',
			'class': 'logging.NullHandler',
		},
		'console': {
			'level': 'DEBUG' if DEBUG else 'INFO',
			'class': 'logging.StreamHandler',
			'formatter': 'console',
		},
		'operation': {
			'level': 'INFO',
			'class': 'logging.StreamHandler',
			'formatter': 'operation',
		},
	},
	'loggers': {
		'horizon': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'horizon.operation_log': {
			'handlers': ['operation'],
			'level': 'INFO',
			'propagate': False,
		},
		'openstack_dashboard': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'novaclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'cinderclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'keystoneauth': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'keystoneclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'glanceclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'neutronclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'swiftclient': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'oslo_policy': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'openstack_auth': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'django': {
			'handlers': ['console'],
			'level': 'DEBUG',
			'propagate': False,
		},
		'django.template': {
			'handlers': ['console'],
			'level': 'INFO',
			'propagate': False,
		},
		'django.db.backends': {
			'handlers': ['null'],
			'propagate': False,
		},
		'requests': {
			'handlers': ['null'],
			'propagate': False,
		},
		'urllib3': {
			'handlers': ['null'],
			'propagate': False,
		},
		'chardet.charsetprober': {
			'handlers': ['null'],
			'propagate': False,
		},
		'iso8601': {
			'handlers': ['null'],
			'propagate': False,
		},
		'scss': {
			'handlers': ['null'],
			'propagate': False,
		},
	},
}
SECURITY_GROUP_RULES = {
	'all_tcp': {
		'name': _('All TCP'),
		'ip_protocol': 'tcp',
		'from_port': '1',
		'to_port': '65535',
	},
	'all_udp': {
		'name': _('All UDP'),
		'ip_protocol': 'udp',
		'from_port': '1',
		'to_port': '65535',
	},
	'all_icmp': {
		'name': _('All ICMP'),
		'ip_protocol': 'icmp',
		'from_port': '-1',
		'to_port': '-1',
	},
	'ssh': {
		'name': 'SSH',
		'ip_protocol': 'tcp',
		'from_port': '22',
		'to_port': '22',
	},
	'smtp': {
		'name': 'SMTP',
		'ip_protocol': 'tcp',
		'from_port': '25',
		'to_port': '25',
	},
	'dns': {
		'name': 'DNS',
		'ip_protocol': 'tcp',
		'from_port': '53',
		'to_port': '53',
	},
	'http': {
		'name': 'HTTP',
		'ip_protocol': 'tcp',
		'from_port': '80',
		'to_port': '80',
	},
	'pop3': {
		'name': 'POP3',
		'ip_protocol': 'tcp',
		'from_port': '110',
		'to_port': '110',
	},
	'imap': {
		'name': 'IMAP',
		'ip_protocol': 'tcp',
		'from_port': '143',
		'to_port': '143',
	},
	'ldap': {
		'name': 'LDAP',
		'ip_protocol': 'tcp',
		'from_port': '389',
		'to_port': '389',
	},
	'https': {
		'name': 'HTTPS',
		'ip_protocol': 'tcp',
		'from_port': '443',
		'to_port': '443',
	},
	'smtps': {
		'name': 'SMTPS',
		'ip_protocol': 'tcp',
		'from_port': '465',
		'to_port': '465',
	},
	'imaps': {
		'name': 'IMAPS',
		'ip_protocol': 'tcp',
		'from_port': '993',
		'to_port': '993',
	},
	'pop3s': {
		'name': 'POP3S',
		'ip_protocol': 'tcp',
		'from_port': '995',
		'to_port': '995',
	},
	'ms_sql': {
		'name': 'MS SQL',
		'ip_protocol': 'tcp',
		'from_port': '1433',
		'to_port': '1433',
	},
	'mysql': {
		'name': 'MYSQL',
		'ip_protocol': 'tcp',
		'from_port': '3306',
		'to_port': '3306',
	},
	'rdp': {
		'name': 'RDP',
		'ip_protocol': 'tcp',
		'from_port': '3389',
		'to_port': '3389',
	},
}
