# coding: utf8
# python3 only

import json
# json.loads() : str -> objet
# json.dumps() : objet -> str

from base64 import b64encode,b64decode
# b64encode : byteslike -> bytes
# b64decode : byteslike -> bytes  

import sys
assert sys.version_info[0] >= 3 , "Python 3 required"

class myData:
    """ classe pour gérer la serialisation/deserialisation json et base64 de n'importe quel objet Python """

    def __init__(self,raw_input: object=u''):
        self.raw_data=raw_input
        self.json_b64_str=self.to_base64str() # Pour declencher tout de suite une exception si raw_input n'est pas serialisable.

    # 2 methodes utilitaires parce que je me rapelle jamais lequel est encode et lequel est decode
    @staticmethod
    def str_to_bytes(data_str: str) -> bytes:
        return data_str.encode()

    @staticmethod
    def bytes_to_str(data_bytes: bytes) -> str:
        return data_bytes.decode()

    def to_base64str(self) -> str:
        """ Renvoie une chaine unicode contenant le json encodé en base64 """
        json_str=json.dumps(self.raw_data)
        base64_bytes=b64encode(self.str_to_bytes(json_str))
        self.json_b64_str=self.bytes_to_str(base64_bytes)
        return self.json_b64_str
    
    def from_base64str(self,base64_str: str):
        """ initialise l'objet à partir d'une chaine unicode contenant du json encodé en base64 """
        base64_bytes=self.str_to_bytes(base64_str)
        json_bytes=b64decode(base64_bytes)
        json_str=self.bytes_to_str(json_bytes)
        self.raw_data=json.loads(json_str)

    def get_raw(self):
        """ renvoie l'objet brut contenu """
        return self.raw_data


def type_and_value(obj: object ) -> str:
    return '{}: {}'.format(type(obj),obj)

# un dico simple
a={'a':'Bonjour tatayé'}
print(type_and_value(a))

data=myData(a)

bstr=data.to_base64str()
print(type_and_value(bstr))

raw=data.get_raw()
print(type_and_value(raw))

data=myData()
data.from_base64str(bstr)
raw=data.get_raw()
print(type_and_value(raw))

# un truc pas serialisable par json.dumps()
a=json.JSONEncoder()
print(type_and_value(myData(a).to_base64str()))