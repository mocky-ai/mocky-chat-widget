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
- Documentation: https://mocky.ai
- Support: support@mocky.ai
- GitHub: https://github.com/mocky-ai/mocky-ai-chat-widget

## Version History
- v1.0.0 (2025-09-30): Initial release
