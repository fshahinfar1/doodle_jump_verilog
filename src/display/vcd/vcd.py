from bitarray import bitarray


# file orientation 
def is_begin_scope_def(line):
    return line.startswith('$scope')

def is_end_scope_def(line):
    return line.startswith('$unscope')

def is_var_def(line):
    return line.startswith('$var')

def is_end_def(line):
    return line.startswith('$enddefinitions')

def is_dumpvar_sec(line):
    return line.startswith('$dumpvars')

def is_end(line):
    return line.startswith('$end')


# data parsing
def get_module_name(line):
    # expects the line to be scope definition
    return line.split()[2]

def get_symbol(line):
    if (line[0].lower() == 'b'):
        return line.split()[1]
    # FIXME: assume all symbols are single character
    return line[-1]

def signal_from_def_line(line):
    raw = line.split()
    name, symbol, t = raw[4], raw[3], (raw[1]+'_'+raw[2])
    s = Signal(name, symbol, t)
    return s

def get_val(line):
    if (line[0].lower() == 'b'):
        return pars_vec_line(line)
    return int(line[0])

def pars_vec_line(line):
    val, symb = line[1:].split()
    val = bitarray(map(lambda x: x == '1', val))
    print(val)
    return val


# model classes
class Signal:
    def __init__(self, name, symbol, _type):
        self.name = name
        self.symbol = symbol
        self.type = _type


class Module:
    def __init__(self, name):
        self.name = name
        self.signals = list()

    def add_signal(self, s):
        assert isinstance(s, Signal)
        self.signals.append(s)

    def __contains__(self, signal_name):
        s = self.get_signal(signal_name)
        return s is not None

    def get_signal(self, signal_name):
        for s in self.signals:
            if s.name == signal_name:
                return s 
        return None


# reader class
class VCDReader:
    def __init__(self, _file_path):
        self._file = open(_file_path)
        self._modules = dict()
        self._callbacks = dict()

        self._read_header()
        self._read_variable_definition()


    def _read_header(self):
        # skip header
        perv_pos = 0
        while (True):
            prev_pos = self._file.tell()
            line = self._file.readline()
            if is_begin_scope_def(line):
                # begining of variable definition
                break
        self._file.seek(prev_pos)

        
    def _read_variable_definition(self):
        # Not supporting nested modules yet
        f = self._file
        line = f.readline()
        if not is_begin_scope_def(line):
            raise Exception('Expected a scope definition')
        module_name = get_module_name(line)
        cur_mod = Module(module_name)
        self._modules[module_name] = cur_mod
        while (True):
            line = f.readline() 
            if is_begin_scope_def(line):
                # not supporting nested modules yet
                # only the root is considered
                break
            elif is_var_def(line):
                s = signal_from_def_line(line)
                cur_mod.add_signal(s)
            elif is_end_scope_def(line):
                # end of a scope
                # not supporting nested modules yet
                break
        # skip until dump vars section
        while (True):
            line = f.readline()
            if is_end_def(line):
                break

    def get_modules_name(self):
        return self._modules.keys()

    def register_on_signal(self, module_name, signal_name, callback):
        if module_name not in self._modules:
            raise Exception('module name not found')
        m = self._modules[module_name]
        if signal_name not in m:
            raise Exception('module does not have this signal')
        s = m.get_signal(signal_name) 
        symbol = s.symbol
        if symbol not in self._callbacks:
            self._callbacks[symbol] = list()
        self._callbacks[symbol].append(callback)

    def start_parsing(self):
        # start from dumpvar section
        f = self._file
        line = f.readline()
        while line.startswith('#'):
            line = f.readline()
            # skip the timstamp
            continue
        if not is_dumpvar_sec(line):
            raise Exception('start called but file state is not expected')
        while True:
            line = f.readline()
            if is_end(line):
                break

            symbol = get_symbol(line)
            if symbol in self._callbacks:
                val = get_val(line)
                for callback in self._callbacks[symbol]:
                    callback(val, 0) # value, timestamp,

    def next(self):
        # parse until next callback
        # return false if file finished true if it has more
        f = self._file
        while True:
            line = f.readline()
            if line == '':
                # file ended
                return False
            if line.startswith('#'):
                # TODO: don't throw away the sampling time
                continue
            symbol = get_symbol(line)
            if symbol in self._callbacks:
                list_callbacks = self._callbacks[symbol]
                val = get_val(line)
                for c in list_callbacks:
                    c(val, 0) # timestamp not updating
                return True

