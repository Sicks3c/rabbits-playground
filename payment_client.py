
import os
import requests
from typing import Optional

class APIClient:
    """Client for interacting with the payment processing API."""
    
    def __init__(self, api_key: str, base_url: str = 'https://api.example.com'):
        self.api_key = api_key
        self.base_url = base_url
        self.session = requests.Session()
        self.session.headers.update({
            'Authorization': f'Bearer {api_key}',
            'Content-Type': 'application/json'
        })
    
    def process_payment(self, amount: float, currency: str, card_token: str) -> dict:
        """Process a payment with the given card token."""
        payload = {
            'amount': amount,
            'currency': currency,
            'card_token': card_token,
            'merchant_id': os.environ.get('MERCHANT_ID')
        }
        response = self.session.post(f'{self.base_url}/v1/payments', json=payload)
        response.raise_for_status()
        return response.json()
    
    def get_user_data(self, user_id: str) -> dict:
        """Fetch user data by ID - potential IDOR if not properly authorized."""
        response = self.session.get(f'{self.base_url}/v1/users/{user_id}')
        return response.json()
    
    def upload_document(self, url: str) -> dict:
        """Upload a document from a URL - SSRF risk if url is user-controlled."""
        response = self.session.post(
            f'{self.base_url}/v1/documents/upload',
            json={'document_url': url}
        )
        return response.json()
