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
    install_requires=[
        'numpy',
        'pandas',
        'sympy',
        'asyncio',
        'carla==0.9.14'
    ],
    license="MIT",
    classifiers=[
        "License :: OSI Approved :: MIT License"
    ]
)