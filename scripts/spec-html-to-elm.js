#!/usr/bin/env node
/* eslint-disable import/no-extraneous-dependencies */
const fs = require('fs');
const program = require('commander');
const { repeat, camelCase } = require('lodash');

// Utils
const indent = (string, { levels = 1 } = {}) => string.replace(/^/gm, repeat('    ', levels));
const stdin = fs.readFileSync(0, 'utf8');

// spec-html-to-elm entity <IFC class>
program
  .command('entity <ifc-class>')
  .description(
    'build an Entity from an IFC class. Copy the Attribute Inheritance table from the HTML docs of the IFC class and pipe it to this command',
  )
  .action((ifcClass) => {
    const functionName = camelCase(ifcClass);

    const attributes = stdin
      .split(/\n/)
      .filter(l => l.match(/^\d+\t/))
      .map((l) => {
        const [, ifcAttribute, ifcType, cardinality] = l.split(/\t/);
        const elmParameter = camelCase(ifcAttribute);
        const isOptional = cardinality === '?';
        const isList = cardinality.match(/\[/);
        const [elmType, elmAttributeFunction] = (ifcType === 'IfcLabel' && ['String', 'string'])
          || (ifcType === 'IfcText' && ['String', 'string'])
          || (ifcType === 'IfcReal' && ['Float', 'float'])
          || (ifcType === 'IfcLengthMeasure' && ['Float', 'float'])
          || (ifcType === 'IfcPositiveLengthMeasure' && ['Float', 'float'])
          || (/Enum$/.test(ifcType) && ['String', 'enum']) || ['Entity', 'referenceTo'];
        return {
          elmParameter,
          elmType,
          elmAttributeFunction,
          ifcType,
          isOptional,
          isList,
        };
      });

    const extendsIfcRoot = /^IfcRoot$/m.test(stdin);
    const attributesRecordAnnotation = attributes
      .filter(attribute => attribute.ifcType !== 'IfcGloballyUniqueId')
      .map((attribute) => {
        const typeWithList = attribute.isList ? `List (${attribute.elmType})` : attribute.elmType;
        const typeWithMaybe = attribute.isOptional ? `Maybe (${typeWithList})` : typeWithList;
        return ` ${attribute.elmParameter} : ${typeWithMaybe}\n`;
      })
      .join(',');
    const typeAnnotation = `${functionName} :\n${indent(
      `{${attributesRecordAnnotation}}\n-> ${extendsIfcRoot ? 'UniqueEntity' : 'Entity'}`,
    )}`;

    const attributeMapping = attribute => ` ${attribute.isOptional ? 'optional ' : ''}${attribute.isList ? 'list ' : ''}${
      attribute.elmAttributeFunction
    } ${attribute.elmParameter}\n`;
    const functionBody = extendsIfcRoot
      ? `${functionName} attributes =\n    ifcRootEntity "${ifcClass}"\n${indent(
        `attributes\n[${attributes
          .slice(4)
          .map(attribute => ({
            ...attribute,
            elmParameter: `attributes.${attribute.elmParameter}`,
          }))
          .map(attributeMapping)
          .join(',')}]`,
        { levels: 2 },
      )}`
      : `${functionName} { ${attributes
        .map(attribute => attribute.elmParameter)
        .join(', ')} } =\n    Step.entity "${ifcClass}"\n${indent(
        `[${attributes.map(attributeMapping).join(',')}]`,
        { levels: 2 },
      )}`;

    process.stdout.write(`${typeAnnotation}\n${functionBody}\n`);
  });

program.parse(process.argv);
