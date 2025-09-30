# Copyright 2025 Mocky LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.

___INFO___

{
  "type": "TAG",
  "id": "mocky_ai_chat_widget",
  "version": 1,
  "securityGroups": [],
  "displayName": "Mocky AI Chat Widget",
  "brand": {
    "id": "mocky_ai",
    "displayName": "Mocky AI"
  },
  "description": "Deploy Mocky AI Chat Widget with AI SDK v5 streaming support, product carousels, and intelligent filtering. Secure, CSP-compliant, and GTM-optimized.",
  "containerContexts": [
    "WEB"
  ],
  "categories": [
    "CHAT",
    "CONVERSIONS",
    "LEAD_GENERATION",
    "PERSONALIZATION"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "widgetId",
    "displayName": "Widget ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$"
        ],
        "errorMessage": "Widget ID must be a valid UUID format"
      }
    ],
    "help": "Your unique Mocky Widget ID (UUID format). Find this in your Mocky dashboard.",
    "valueHint": "2da8af4e-e0ff-4c74-94bf-8260010594b4"
  },
  {
    "type": "TEXT",
    "name": "tenantId",
    "displayName": "Tenant ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$"
        ],
        "errorMessage": "Tenant ID must be a valid UUID format"
      }
    ],
    "help": "Your Mocky Tenant ID (UUID format). Find this in your Mocky dashboard.",
    "valueHint": "60cacdcf-3495-4c0a-b3aa-bebebbb81222"
  },
  {
    "type": "TEXT",
    "name": "apiUrl",
    "displayName": "API URL",
    "simpleValueType": true,
    "defaultValue": "https://chat.mocky.ai",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      },
      {
        "type": "REGEX",
        "args": [
          "^https://.*"
        ],
        "errorMessage": "API URL must start with https://"
      }
    ],
    "help": "Mocky API endpoint URL. Use default unless instructed otherwise."
  },
  {
    "type": "TEXT",
    "name": "version",
    "displayName": "Widget Version",
    "simpleValueType": true,
    "defaultValue": "1.0.0",
    "help": "Widget version for tracking and debugging purposes."
  },
  {
    "type": "TEXT",
    "name": "externalUserId",
    "displayName": "External User ID (Optional)",
    "simpleValueType": true,
    "help": "Optional: Your internal user ID for tracking authenticated users.",
    "valueHint": "user_12345"
  },
  {
    "type": "GROUP",
    "name": "advancedSettings",
    "displayName": "Advanced Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableDebugMode",
        "checkboxText": "Enable Debug Mode",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Enable console logging for debugging purposes."
      },
      {
        "type": "CHECKBOX",
        "name": "loadOnPageLoad",
        "checkboxText": "Load Widget on Page Load",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Load widget immediately when page loads. Uncheck for manual initialization."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Require GTM APIs
var injectScript = require('injectScript');
var createQueue = require('createQueue');
var callInWindow = require('callInWindow');
var copyFromWindow = require('copyFromWindow');
var setInWindow = require('setInWindow');
var logToConsole = require('logToConsole');
var makeTableMap = require('makeTableMap');
var getTimestampMillis = require('getTimestampMillis');

// Get template data
var widgetId = data.widgetId;
var tenantId = data.tenantId;
var apiUrl = data.apiUrl;
var version = data.version || '1.0.0';
var externalUserId = data.externalUserId;
var enableDebugMode = data.enableDebugMode || false;
var loadOnPageLoad = data.loadOnPageLoad !== false;

// Debug logging helper
function debug(message, obj) {
  if (enableDebugMode) {
    if (obj) {
      logToConsole('[Mocky Widget GTM]', message, obj);
    } else {
      logToConsole('[Mocky Widget GTM]', message);
    }
  }
}

debug('Initializing Mocky Widget', {
  widgetId: widgetId,
  tenantId: tenantId,
  apiUrl: apiUrl,
  version: version
});

// Validate required parameters
if (!widgetId || !tenantId) {
  logToConsole('[Mocky Widget GTM] ERROR: widgetId and tenantId are required');
  data.gtmOnFailure();
  return;
}

// Set widget configuration in window
var config = {
  widgetId: widgetId,
  tenantId: tenantId,
  apiUrl: apiUrl,
  version: version
};

if (externalUserId) {
  config.externalUserId = externalUserId;
}

setInWindow('MockyWidgetConfig', config, true);

debug('Configuration set', config);

// Widget script URL - inline the ES5 transpiled code
var widgetScriptUrl = 'https://chat.mocky.ai/widget/js/1.0.0/mocky-widget.js';

// Success callback
var onSuccess = function() {
  debug('Widget script loaded successfully');
  
  // Initialize widget if loadOnPageLoad is enabled
  if (loadOnPageLoad) {
    debug('Auto-initializing widget');
  }
  
  data.gtmOnSuccess();
};

// Failure callback
var onFailure = function() {
  logToConsole('[Mocky Widget GTM] ERROR: Failed to load widget script');
  data.gtmOnFailure();
};

// Inject the widget script
debug('Injecting widget script from:', widgetScriptUrl);
injectScript(widgetScriptUrl, onSuccess, onFailure, widgetScriptUrl);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "MockyWidgetConfig"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "MockyWidget"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "MockyDebug"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://chat.mocky.ai/"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]

___TESTS___

scenarios:
- name: Widget initialization with valid config
  code: |-
    const mockData = {
      widgetId: '2da8af4e-e0ff-4c74-94bf-8260010594b4',
      tenantId: '60cacdcf-3495-4c0a-b3aa-bebebbb81222',
      apiUrl: 'https://chat.mocky.ai',
      version: '1.0.0',
      enableDebugMode: true,
      loadOnPageLoad: true
    };

    // Run the template
    runCode(mockData);

    // Verify script injection was called
    assertApi('injectScript').wasCalled();

    // Verify configuration was set
    assertApi('setInWindow').wasCalledWith('MockyWidgetConfig');
- name: Widget initialization fails without widgetId
  code: |-
    const mockData = {
      tenantId: '60cacdcf-3495-4c0a-b3aa-bebebbb81222',
      apiUrl: 'https://chat.mocky.ai'
    };

    // Run the template
    runCode(mockData);

    // Verify gtmOnFailure was called
    assertApi('gtmOnFailure').wasCalled();
- name: Widget initialization fails without tenantId
  code: |-
    const mockData = {
      widgetId: '2da8af4e-e0ff-4c74-94bf-8260010594b4',
      apiUrl: 'https://chat.mocky.ai'
    };

    // Run the template
    runCode(mockData);

    // Verify gtmOnFailure was called
    assertApi('gtmOnFailure').wasCalled();


___NOTES___

Created on 30/09/2025, 12:00:00
Version: 1.0.0

# Mocky AI Chat Widget - GTM Custom Template

## Overview
This template deploys the Mocky AI Chat Widget on your website through Google Tag Manager. The widget provides:
- AI-powered chat interface with streaming responses
- Product carousel with intelligent filtering
- Session management and message history
- Mobile-responsive glassmorphic design
- CSP-compliant and security-hardened

## Configuration
1. **Widget ID**: Your unique Mocky widget identifier (UUID format)
2. **Tenant ID**: Your Mocky tenant identifier (UUID format)
3. **API URL**: Mocky API endpoint (default: https://chat.mocky.ai)
4. **External User ID**: (Optional) Your internal user tracking ID

## Advanced Settings
- **Debug Mode**: Enable console logging for troubleshooting
- **Load on Page Load**: Auto-initialize widget when page loads

## Permissions Required
- **Inject Scripts**: To load the widget JavaScript from chat.mocky.ai
- **Access Globals**: To configure widget settings (MockyWidgetConfig)
- **Logging**: For debug mode console output

## Security
- CSP-compliant (no eval, no inline handlers)
- XSS protection with HTML sanitization
- Input validation on all user inputs
- Secure HTTPS-only API communication
- No credential storage in browser

## Support
For issues or questions:
- Documentation: https://docs.mocky.ai
- Support: support@mocky.ai
- GitHub: https://github.com/mocky-ai/widget

## Version History
- v1.0.0 (2025-09-30): Initial release

