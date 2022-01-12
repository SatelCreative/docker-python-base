from webapp.main import dummy_func


def test_dummy_func():
    assert dummy_func() == 'ok'
