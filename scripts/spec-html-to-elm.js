#!/usr/bin/env node
const fs = require('fs');

const indent = string => string.replace(/^/gm, '    ');

const stdin = fs.readFileSync(0, 'utf8');
const attributes = stdin
  .split(/\n/)
  .filter(l => l.match(/^\d+\t/))
  .map((l) => {
    const [, ifcAttribute, ifcType, cardinality] = l.split(/\t/);
    const elmParameter = ifcAttribute[0].toLowerCase() + ifcAttribute.slice(1);
    const isOptional = cardinality === '?';
    const isList = cardinality.match(/\[/);
    return {
      elmParameter,
      ifcType,
      isOptional,
      isList,
    };
  });

process.stdout.write(
  `Type:\n${indent(
    `{${attributes
      .map((attribute) => {
        const elmType = `${attribute.isList ? 'List ' : ''}${{
          IfcLabel: 'String',
          IfcText: 'String',
        }[attribute.ifcType] || 'Entity'}`;
        return ` ${attribute.elmParameter} : ${(attribute.isOptional
          && attribute.isList
          && `Maybe (${elmType})`)
          || (attribute.isOptional && `Maybe ${elmType}`)
          || elmType}\n`;
      })
      .join(',')}}`,
  )}\n`,
);

process.stdout.write('\n');

process.stdout.write(
  `Mapping:\n${indent(
    `[${attributes
      .map(
        attribute => ` ${attribute.isOptional ? 'optional ' : ''}${attribute.isList ? 'list ' : ''}${{
          IfcLabel: 'label',
          IfcText: 'string',
        }[attribute.ifcType] || 'referenceTo'} ${attribute.elmParameter}\n`,
      )
      .join(',')}]`,
  )}\n`,
);
