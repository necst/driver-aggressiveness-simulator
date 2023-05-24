from setuptools import setup, find_packages

with open('README.md', 'r', encoding='UTF-8') as f:
    long_description = f.read()

setup(
    name='dasimulator',
    long_description=long_description,
    url='https://github.com/necst/driver-aggressiveness-simulator.git',
    version='0.1.0',
    author='Matteo Santelmo',
    author_email='matteo.santelmo@mail.polimi.it',
    package_dir={"": "src"},
    packages=find_packages(where='src'),
    # FIXME: the correct version for carla would be 0.9.14 but for some reason it's not in the list of available versions during docker build
    # This is probably linked to an uncorrect handling of python versions in the docker image.
    install_requires=[
        'numpy',
        'pandas',
        'sympy',
        'asyncio',
        'carla==0.9.13'
    ],
    license="MIT",
    classifiers=[
        "License :: OSI Approved :: MIT License"
    ]
)