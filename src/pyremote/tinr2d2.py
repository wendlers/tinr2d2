import serial


class TinR2D2:

    def __init__(self, port):

        #self.s = serial.Serial(port=port, timeout=10)
        #self.send("+p")
        pass

    def send(self, msg):

        '''
        self.s.flushInput()
        l = self.s.write(msg + "\r")

        return l
        '''
        return 0

    def receive(self):

        '''
        result = ""

        while True:

            c = self.s.read(1)

            # print("%d" % ord(c))

            if len(c) == 0 or ord(c) == 10:
                break

            if ord(c) != 13:
                result += c

        if result.startswith("!ERR "):
            raise Exception("TinR2D2 returned an error: %s" % result[5:])

        return result[6:]
        '''

        return "OK"

    def stop(self):

        self.send("+d s")
        return self.receive()

    def forward(self):

        self.send("+d f")
        return self.receive()

    def backward(self):

        self.send("+d b")
        return self.receive()

    def left(self):

        self.send("+d l")
        return self.receive()

    def right(self):

        self.send("+d r")
        return self.receive()

    def sound(self):

        self.send("+p")

    def range(self):

        self.send("+r")
        return int(self.receive()[7:])



