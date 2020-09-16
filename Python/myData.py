import json
# json.loads() : str -> objet
# json.dumps() : objet -> str

from base64 import b64encode,b64decode
# b64encode : byteslike -> bytes
# b64decode : byteslike -> bytes  


from pprint import pprint

class myData:
    """ classe pour gérer la serialisation/deserialisation json et base64 de n'importe quel objet Python """

    encoding='ascii'

    def __init__(self,raw_input=b''):
        self.raw_data=raw_input

    @classmethod
    def str_to_bytes(cls,data_str):
        return data_str.encode(cls.encoding)

    @classmethod
    def bytes_to_str(cls,data_bytes):
        return data_bytes.decode(cls.encoding)

    def to_base64str(self):
        json_str=json.dumps(self.raw_data)
        base64_bytes=b64encode(self.str_to_bytes(json_str))
        return self.bytes_to_str(base64_bytes)
    
    def from_base64str(self,base64_str):
        base64_bytes=self.str_to_bytes(base64_str)
        json_bytes=b64decode(base64_bytes)
        json_str=self.bytes_to_str(json_bytes)
        self.raw_data=json.loads(json_str)

    def get_raw(self):
        return self.raw_data

# un dico simple
a={'a':'Bonjour'}

data=myData(a)
bstr=data.to_base64str()
pprint(bstr)
pprint(data.get_raw())

data=myData()
data.from_base64str(bstr)
pprint(data.get_raw())

